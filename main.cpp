#include <cstdlib>
#include <QCommandLineOption>
#include <QCommandLineParser>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>
#include <QtWebEngineQuick/qtwebenginequickglobal.h>

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QtWebEngineQuick::initialize();
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName("kiosk-browser");

    QCommandLineParser parser;
    parser.setApplicationDescription(
        "Fullscreen kiosk browser with an embedded on-screen keyboard");
    parser.addHelpOption();
    parser.addPositionalArgument("url", "Page to display.");

    QCommandLineOption windowedOption(
        "windowed",
        "Do not start in fullscreen (for development).");
    parser.addOptions({windowedOption});

    parser.process(app);

    const QStringList positional = parser.positionalArguments();
    if (positional.size() != 1) {
        qCritical("Exactly one URL is required.");
        parser.showHelp(EXIT_FAILURE);
    }
    const QUrl url = QUrl::fromUserInput(positional.first());
    if (!url.isValid()) {
        qCritical("Invalid URL: %s", qPrintable(positional.first()));
        return EXIT_FAILURE;
    }

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    context->setContextProperty("kioskUrl", url);
    context->setContextProperty("kioskFullscreen", !parser.isSet(windowedOption));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(EXIT_FAILURE); },
        Qt::QueuedConnection);
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
    engine.loadFromModule("KioskBrowser", "Main");
#else
    engine.load(QUrl("qrc:/qt/qml/KioskBrowser/Main.qml"));
#endif
    if (engine.rootObjects().isEmpty()) {
        return EXIT_FAILURE;
    }

    return app.exec();
}
