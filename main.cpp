#include <QtGui/QApplication>
#include <QDeclarativeContext>
#include <QtDeclarative>
#include <QTranslator>
#include <QtGui/QDirModel>
#include <QSettings>
#include "qmlapplicationviewer.h"
#include "utils.h"
#include <qplatformdefs.h> // MEEGO_EDITION_HARMATTAN

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QmlApplicationViewer viewer;
    QSettings settings("MK","Ubi");
    Utils utils(&viewer,&settings);

    QString locale = settings.value("locale").toString();
    if(locale!="pl_PL" && locale!="en_US" && locale!="it_IT") {
        locale = QLocale::system().name();
        if(locale!="pl_PL" && locale!="it_IT") {
            locale="en_US";
        }
        settings.setValue("locale",locale);
    }
    QTranslator translator;
    QString dir = "translations";
    dir = ":/translations";
#if defined(MEEGO_EDITION_HARMATTAN)
    dir = ":/translations";
#endif
#if defined(Q_WS_MAEMO_5)
    //dir = "/opt/ubi/translations";
    dir = ":/translations";
#endif
    if (translator.load(QString("ubi.")+locale,dir)) {
        app->installTranslator(&translator);
    } else {
        locale="en_US";
        settings.setValue("locale",locale);
    }

    QDeclarativeContext *context = viewer.rootContext();
    context->setContextProperty("Utils", &utils);

#if defined(MEEGO_EDITION_HARMATTAN)
    //viewer.setMainQmlFile(QLatin1String("qml/ubi/meego_main.qml"));
    viewer.setSource(QUrl("qrc:///qml/ubi/meego_main.qml"));
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
#endif

#if defined(Q_WS_MAEMO_5)
    qputenv("N900_PORTRAIT_SENSORS", "1");
    //viewer.setMainQmlFile(QLatin1String("qml/ubi/meego_main.qml"));
    viewer.setSource(QUrl("qrc:///qml/ubi/main.qml"));
    //viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockLandscape);
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setGeometry(QRect(0,0,800,480));
#endif

#if !defined(MEEGO_EDITION_HARMATTAN) && !defined(Q_WS_MAEMO_5)
    //viewer.setMainQmlFile(QLatin1String("qml/ubi/main.qml"));
    viewer.setSource(QUrl("qrc:///qml/ubi/main.qml"));
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
#endif

    viewer.setWindowTitle(QString("Ubi"));
    viewer.showExpanded();

/*
#if defined(Q_WS_MAEMO_5)
    viewer.setGeometry(QRect(0,0,800,480));
    viewer.showFullScreen();
#else
    viewer.showExpanded();
#endif
*/

    return app->exec();
}
