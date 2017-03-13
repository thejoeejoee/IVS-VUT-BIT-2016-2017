#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <types/sides.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/assets/styles/UIStyles.qml")), "StyleSettings", 1, 0, "StyleSettings");
    qmlRegisterSingletonType<Sides>("Sides", 1, 0, "Sides", Sides::singletonProvider);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("../../../src/calculator/ui/qml/main.qml")));

    return app.exec();
}
