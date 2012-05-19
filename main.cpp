#include <QtGui/QApplication>
#include <QDeclarativeContext>
#include <QtDeclarative>
#include <QTranslator>
#include <QtGui/QDirModel>
#include <QSettings>
#include "qmlapplicationviewer.h"
#include "utils.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    QSettings settings("MK","Ubi");
    Utils utils(&viewer,&settings);

    QString locale = settings.value("locale").toString();

    if(locale!="pl_PL" && locale!="en_US") {
        locale = QLocale::system().name();
        if(locale!="pl_PL") {
            locale="en_US";
        }
        settings.setValue("locale",locale);
    }

    QTranslator translator;
    //QString dir = "translations";
    QString dir = ":/translations";
#if defined(Q_WS_MAEMO_5)
    //dir = "/opt/ubi/"+dir;
#endif
    if (translator.load(QString("ubi.")+locale,dir)) {
        app->installTranslator(&translator);
    } else {
        locale="en_US";
        settings.setValue("locale",locale);
    }

    QDeclarativeContext *context = viewer.rootContext();
    context->setContextProperty("Utils", &utils);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
#if defined(Q_WS_MAEMO_5)
    //viewer.engine()->addImportPath(QString("/opt/qtm12/imports"));
#endif
    //viewer.setMainQmlFile(QLatin1String("qml/ubi/main.qml"));
    viewer.setSource(QUrl("qrc:///qml/ubi/main.qml"));
    viewer.setWindowTitle(QString("Ubi"));

#if defined(Q_WS_MAEMO_5)
    viewer.setGeometry(QRect(0,0,800,480));
    viewer.showFullScreen();
#else
    viewer.showExpanded();
#endif

    return app->exec();
}
