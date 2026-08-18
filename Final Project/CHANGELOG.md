#ifndef AUDIOPLAYER_H
#define AUDIOPLAYER_H

#include <QObject>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QStringList>
#include <QVariantList>

class AudioPlayer : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool playing READ playing NOTIFY playingChanged)
    Q_PROPERTY(qint64 position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(bool muted READ muted WRITE setMuted NOTIFY mutedChanged)
    Q_PROPERTY(float volume READ volume WRITE setVolume NOTIFY volumeChanged)

    Q_PROPERTY(QStringList playlist READ playlist NOTIFY playlistChanged)
    Q_PROPERTY(int currentPlaylistIndex READ currentPlaylistIndex NOTIFY currentPlaylistIndexChanged)

    Q_PROPERTY(QString audioTitle READ audioTitle NOTIFY metadataChanged)
    Q_PROPERTY(QString audioAuthor READ audioAuthor NOTIFY metadataChanged)
    Q_PROPERTY(QString audioAlbum READ audioAlbum NOTIFY metadataChanged)
    Q_PROPERTY(QString audioType READ audioType NOTIFY metadataChanged)

    Q_PROPERTY(QString errorString READ errorString NOTIFY errorOccurred)

    Q_PROPERTY(QVariantList radioStations READ radioStations NOTIFY radioStationsChanged)
    Q_PROPERTY(QString currentRadioStationName READ currentRadioStationName NOTIFY radioStationChanged)
    Q_PROPERTY(QString currentRadioStationCountry READ currentRadioStationCountry NOTIFY radioStationChanged)

public:
    explicit AudioPlayer(QObject *parent = nullptr);

    bool playing() const;
    qint64 position() const;
    qint64 duration() const;
    bool muted() const;
    float volume() const;

    QStringList playlist() const;
    int currentPlaylistIndex() const;

    QString audioTitle() const;
    QString audioAuthor() const;
    QString audioAlbum() const;
    QString audioType() const;
    QString errorString() const;

    QVariantList radioStations() const;
    QString currentRadioStationName() const;
    QString currentRadioStationCountry() const;

    void setPosition(qint64 value);
    void setMuted(bool value);
    void setVolume(float value);

    Q_INVOKABLE void playPause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();

    Q_INVOKABLE void loadFolder(const QString &folderPath);
    Q_INVOKABLE void playPlaylistIndex(int index);
    Q_INVOKABLE QString formatTime(qint64 ms) const;

    Q_INVOKABLE void playRadioStation(int index);
    Q_INVOKABLE void addRadioStation(const QString &name,
                                     const QString &country,
                                     const QString &url);

    // Bluetooth in this project means PHONE -> IVI SYSTEM.
    // Pairing and the incoming audio route are handled by Linux.
    Q_INVOKABLE bool openBluetoothSettings();

signals:
    void playingChanged();
    void positionChanged();
    void durationChanged();
    void mutedChanged();
    void volumeChanged();

    void playlistChanged();
    void currentPlaylistIndexChanged();
    void metadataChanged();
    void errorOccurred();

    void radioStationsChanged();
    void radioStationChanged();

private:
    void setSource(const QString &source, bool radio = false);
    void setError(const QString &message);
    void clearMetadata();
    void nextRadio();
    void previousRadio();

    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;

    QStringList m_playlist;
    int m_playlistIndex = -1;

    QString m_title;
    QString m_author;
    QString m_album;
    QString m_type;
    QString m_error;

    QVariantList m_radioStations;
    bool m_radioMode = false;
    int m_radioIndex = 0;
    QString m_radioName;
    QString m_radioCountry;
};

#endif
