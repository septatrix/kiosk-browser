#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QtWebEngineQuick/qtwebenginequickglobal.h>

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QtWebEngineQuick::initialize();
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
    engine.loadFromModule("kiosk-browser", "Main");
#else
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/kiosk-browser/Main.qml")));
#endif
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
