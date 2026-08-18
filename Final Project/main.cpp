#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include "audioplayer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<AudioPlayer>("audio_player_live", 1, 0, "AudioPlayer");

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection
    );

    engine.loadFromModule("audio_player_live", "Main");

    return app.exec();
}
