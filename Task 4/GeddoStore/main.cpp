#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>

class LanguageManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentLanguage READ currentLanguage NOTIFY currentLanguageChanged)

public:
    LanguageManager(QGuiApplication *application,
                    QQmlApplicationEngine *engine,
                    QObject *parent = nullptr)
        : QObject(parent),
          m_application(application),
          m_engine(engine)
    {
    }

    QString currentLanguage() const
    {
        return m_currentLanguage;
    }

    Q_INVOKABLE void setLanguage(const QString &languageCode)
    {
        QString requestedLanguage = languageCode == "ar" ? "ar" : "en";

        if (requestedLanguage == m_currentLanguage)
            return;

        m_application->removeTranslator(&m_translator);

        if (requestedLanguage == "ar") {
            if (m_translator.load(":/i18n/store_ar.qm"))
                m_application->installTranslator(&m_translator);
        }

        m_currentLanguage = requestedLanguage;
        emit currentLanguageChanged();

        // Refresh every qsTr() binding in the QML interface.
        m_engine->retranslate();
    }

signals:
    void currentLanguageChanged();

private:
    QGuiApplication *m_application;
    QQmlApplicationEngine *m_engine;
    QTranslator m_translator;
    QString m_currentLanguage = "en";
};

int main(int argc, char *argv[])
{
    QGuiApplication application(argc, argv);
    QQmlApplicationEngine engine;

    LanguageManager languageManager(&application, &engine);
    engine.rootContext()->setContextProperty("languageManager", &languageManager);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &application,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("GeddoStore", "Main");

    return application.exec();
}

#include "main.moc"
