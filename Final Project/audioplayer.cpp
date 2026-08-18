#include "audioplayer.h"

#include <QDir>
#include <QFileInfo>
#include <QMediaMetaData>
#include <QProcess>
#include <QStandardPaths>
#include <QTimer>
#include <QUrl>

AudioPlayer::AudioPlayer(QObject *parent)
    : QObject(parent)
{
    m_player = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);

    m_player->setAudioOutput(m_audioOutput);
    m_audioOutput->setVolume(0.50f);

    connect(m_player, &QMediaPlayer::positionChanged,
            this, &AudioPlayer::positionChanged);

    connect(m_player, &QMediaPlayer::durationChanged,
            this, &AudioPlayer::durationChanged);

    connect(m_player, &QMediaPlayer::playingChanged,
            this, &AudioPlayer::playingChanged);

    connect(m_audioOutput, &QAudioOutput::mutedChanged,
            this, &AudioPlayer::mutedChanged);

    connect(m_audioOutput, &QAudioOutput::volumeChanged,
            this, &AudioPlayer::volumeChanged);

    connect(m_player, &QMediaPlayer::errorOccurred,
            this, [this](QMediaPlayer::Error error, const QString &errorText) {
        if (error == QMediaPlayer::NoError)
            return;

        QString message = errorText.trimmed();
        if (message.isEmpty())
            message = "The media source could not be played";

        setError(message);
    });

    connect(m_player, &QMediaPlayer::metaDataChanged,
            this, [this]() {
        if (m_radioMode)
            return;

        QMediaMetaData data = m_player->metaData();

        QString title = data.stringValue(QMediaMetaData::Title);
        if (!title.isEmpty())
            m_title = title;

        m_author = data.stringValue(QMediaMetaData::ContributingArtist);
        m_album = data.stringValue(QMediaMetaData::AlbumTitle);

        QString genre = data.stringValue(QMediaMetaData::Genre);
        if (!genre.isEmpty())
            m_type = genre;

        emit metadataChanged();
    });

    connect(m_player, &QMediaPlayer::mediaStatusChanged,
            this, [this](QMediaPlayer::MediaStatus status) {
        // Auto-next is useful for normal files, but not for live streams.
        // A failed/ended radio stream must not immediately jump through
        // every station because that can cause repeated source changes.
        if (status == QMediaPlayer::EndOfMedia && !m_radioMode)
            next();
    });

    // HTTPS radio URLs published by the MP3Quran radio API.
    // Keeping the defaults on HTTPS avoids the old legacy HTTP streams.
    m_radioStations = {
        QVariantMap{
            {"name", "Radio Alzain Mohammad Ahmad"},
            {"country", "Quran Radio"},
            {"url", "https://Qurango.net/radio/alzain_mohammad_ahmad"}
        },
        QVariantMap{
            {"name", "Radio Ahmad Khader Al-Tarabulsi"},
            {"country", "Quran Radio"},
            {"url", "https://Qurango.net/radio/ahmad_khader_altarabulsi"}
        }
    };
}

bool AudioPlayer::playing() const
{
    return m_player->isPlaying();
}

qint64 AudioPlayer::position() const
{
    return m_player->position();
}

qint64 AudioPlayer::duration() const
{
    return m_player->duration();
}

bool AudioPlayer::muted() const
{
    return m_audioOutput->isMuted();
}

float AudioPlayer::volume() const
{
    return m_audioOutput->volume();
}

QStringList AudioPlayer::playlist() const
{
    return m_playlist;
}

int AudioPlayer::currentPlaylistIndex() const
{
    return m_playlistIndex;
}

QString AudioPlayer::audioTitle() const
{
    return m_title;
}

QString AudioPlayer::audioAuthor() const
{
    return m_author;
}

QString AudioPlayer::audioAlbum() const
{
    return m_album;
}

QString AudioPlayer::audioType() const
{
    return m_type;
}

QString AudioPlayer::errorString() const
{
    return m_error;
}

QVariantList AudioPlayer::radioStations() const
{
    return m_radioStations;
}

QString AudioPlayer::currentRadioStationName() const
{
    return m_radioName;
}

QString AudioPlayer::currentRadioStationCountry() const
{
    return m_radioCountry;
}

void AudioPlayer::setPosition(qint64 value)
{
    if (duration() <= 0)
        return;

    if (value < 0)
        value = 0;
    if (value > duration())
        value = duration();

    m_player->setPosition(value);
}

void AudioPlayer::setMuted(bool value)
{
    m_audioOutput->setMuted(value);
}

void AudioPlayer::setVolume(float value)
{
    if (value < 0.0f)
        value = 0.0f;
    if (value > 1.0f)
        value = 1.0f;

    m_audioOutput->setVolume(value);
}

void AudioPlayer::playPause()
{
    if (m_player->isPlaying())
        m_player->pause();
    else
        m_player->play();
}

void AudioPlayer::stop()
{
    m_player->stop();
}

void AudioPlayer::next()
{
    if (m_radioMode) {
        nextRadio();
        return;
    }

    if (m_playlist.isEmpty())
        return;

    m_playlistIndex = (m_playlistIndex + 1) % m_playlist.size();
    emit currentPlaylistIndexChanged();

    setSource(m_playlist[m_playlistIndex]);
    m_player->play();
}

void AudioPlayer::previous()
{
    if (m_radioMode) {
        previousRadio();
        return;
    }

    if (m_playlist.isEmpty())
        return;

    m_playlistIndex =
        (m_playlistIndex - 1 + m_playlist.size()) % m_playlist.size();

    emit currentPlaylistIndexChanged();

    setSource(m_playlist[m_playlistIndex]);
    m_player->play();
}

void AudioPlayer::loadFolder(const QString &folderPath)
{
    QUrl url(folderPath);
    QString path = url.toLocalFile();

    if (path.isEmpty())
        path = folderPath;

    QDir folder(path);

    if (!folder.exists()) {
        setError("Folder does not exist");
        return;
    }

    QStringList filters = {
        "*.mp3", "*.wav", "*.m4a", "*.aac", "*.flac",
        "*.MP3", "*.WAV", "*.M4A", "*.AAC", "*.FLAC"
    };

    QFileInfoList files = folder.entryInfoList(filters, QDir::Files, QDir::Name);

    if (files.isEmpty()) {
        setError("No supported audio files were found");
        return;
    }

    m_playlist.clear();

    for (const QFileInfo &file : files)
        m_playlist.append(file.absoluteFilePath());

    m_radioMode = false;
    m_radioName.clear();
    m_radioCountry.clear();
    m_playlistIndex = 0;

    emit playlistChanged();
    emit currentPlaylistIndexChanged();
    emit radioStationChanged();

    setSource(m_playlist[0]);
}

void AudioPlayer::playPlaylistIndex(int index)
{
    if (index < 0 || index >= m_playlist.size())
        return;

    m_radioMode = false;
    m_playlistIndex = index;

    emit currentPlaylistIndexChanged();

    setSource(m_playlist[index]);
    m_player->play();
}

QString AudioPlayer::formatTime(qint64 ms) const
{
    if (ms < 0)
        ms = 0;

    int totalSeconds = static_cast<int>(ms / 1000);
    int hours = totalSeconds / 3600;
    int minutes = (totalSeconds % 3600) / 60;
    int seconds = totalSeconds % 60;

    if (hours > 0) {
        return QString("%1:%2:%3")
            .arg(hours, 2, 10, QChar('0'))
            .arg(minutes, 2, 10, QChar('0'))
            .arg(seconds, 2, 10, QChar('0'));
    }

    return QString("%1:%2")
        .arg(minutes, 2, 10, QChar('0'))
        .arg(seconds, 2, 10, QChar('0'));
}

void AudioPlayer::playRadioStation(int index)
{
    if (index < 0 || index >= m_radioStations.size())
        return;

    QVariantMap station = m_radioStations[index].toMap();
    QString streamText = station.value("url").toString().trimmed();
    QUrl streamUrl = QUrl::fromUserInput(streamText);

    if (!streamUrl.isValid() ||
        (streamUrl.scheme() != "http" && streamUrl.scheme() != "https")) {
        setError("Invalid radio stream URL");
        return;
    }

    // Stop the old source first. This keeps station changes simple and
    // avoids changing an active live stream from inside a media callback.
    m_player->stop();
    m_player->setSource(QUrl());

    m_radioMode = true;
    m_radioIndex = index;
    m_radioName = station.value("name").toString();
    m_radioCountry = station.value("country").toString();

    clearMetadata();
    emit radioStationChanged();

    // Queue the new source for the next event-loop turn. This avoids
    // re-entrant source changes in the FFmpeg backend when a live station
    // is selected immediately after another source.
    const int requestedIndex = index;
    QTimer::singleShot(0, this, [this, streamUrl, requestedIndex]() {
        if (!m_radioMode || m_radioIndex != requestedIndex)
            return;

        m_player->setSource(streamUrl);
        m_player->play();
    });
}

void AudioPlayer::addRadioStation(const QString &name,
                                  const QString &country,
                                  const QString &url)
{
    QString cleanName = name.trimmed();
    QString cleanUrl = url.trimmed();

    if (cleanName.isEmpty() || cleanUrl.isEmpty()) {
        setError("Station name and URL are required");
        return;
    }

    QUrl streamUrl = QUrl::fromUserInput(cleanUrl);

    if (!streamUrl.isValid() ||
        (streamUrl.scheme() != "http" && streamUrl.scheme() != "https")) {
        setError("Enter a valid HTTP or HTTPS radio stream URL");
        return;
    }

    QVariantMap station;
    station["name"] = cleanName;
    station["country"] = country.trimmed().isEmpty()
                             ? "Custom"
                             : country.trimmed();
    station["url"] = streamUrl.toString();

    m_radioStations.append(station);
    emit radioStationsChanged();
}

bool AudioPlayer::openBluetoothSettings()
{
    QString program = QStandardPaths::findExecutable("blueman-manager");

    if (!program.isEmpty())
        return QProcess::startDetached(program);

    program = QStandardPaths::findExecutable("gnome-control-center");

    if (!program.isEmpty())
        return QProcess::startDetached(program, {"bluetooth"});

    program = QStandardPaths::findExecutable("systemsettings");

    if (!program.isEmpty())
        return QProcess::startDetached(program, {"kcm_bluetooth"});

    setError("Could not open Bluetooth settings");
    return false;
}

void AudioPlayer::setSource(const QString &source, bool radio)
{
    m_player->stop();
    m_radioMode = radio;

    QUrl url(source);

    if (url.scheme().isEmpty())
        url = QUrl::fromLocalFile(source);

    if (!radio && url.isLocalFile()) {
        QFileInfo file(url.toLocalFile());
        m_title = file.completeBaseName();
        m_author.clear();
        m_album.clear();
        m_type = file.suffix().toUpper();
        emit metadataChanged();
    }

    m_player->setSource(url);
}

void AudioPlayer::setError(const QString &message)
{
    m_error = message;
    emit errorOccurred();
}

void AudioPlayer::clearMetadata()
{
    m_title.clear();
    m_author.clear();
    m_album.clear();
    m_type.clear();
    emit metadataChanged();
}

void AudioPlayer::previousRadio()
{
    if (m_radioStations.isEmpty())
        return;

    m_radioIndex =
        (m_radioIndex - 1 + m_radioStations.size()) % m_radioStations.size();

    playRadioStation(m_radioIndex);
}

void AudioPlayer::nextRadio()
{
    if (m_radioStations.isEmpty())
        return;

    m_radioIndex = (m_radioIndex + 1) % m_radioStations.size();
    playRadioStation(m_radioIndex);
}
