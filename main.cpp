#include "filemanager.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <qdebug.h>

int
main(int argc, char* argv[]) {

    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication::setOrganizationName("Baadraan");
    QApplication::setApplicationName("Bank File Editor");
    QQuickStyle::setStyle("Universal");

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    baadraan::FileManager fileManager;
    if(argc>1){
        fileManager.setOpenedFilePaht(QString(argv[1]));
    }

    engine.rootContext()->setContextProperty("fileManager", &fileManager);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
