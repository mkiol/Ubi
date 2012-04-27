# Add more folders to ship with the application, here
#folder_01.source = qml/ubi
#folder_01.target = qml
#DEPLOYMENTFOLDERS = folder_01

#folder_02.source = translations/ubi.pl.qm
#folder_02.target = translations
#DEPLOYMENTFOLDERS += folder_02

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE6DE55DD

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

QT = core gui network xml
maemo5 {
    QT += dbus
}

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
#CONFIG += mobility
#MOBILITY = multimedia

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    utils.cpp

#evil_hack_to_fool_lupdate {
#    SOURCES += \
#    qml/ubi/AccountPage.qml \
#    qml/ubi/DownloadArea.qml \
#    qml/ubi/FileSelector.qml \
#    qml/ubi/FilesPage.qml \
#    qml/ubi/LoginPage.qml \
#    qml/ubi/main.qml \
#    qml/ubi/PageStack.qml \
#    qml/ubi/PropertiesPage.qml \
#   qml/ubi/SettingsPage.qml \
#    qml/ubi/Shadow.qml \
#    qml/ubi/StartPage.qml \
#    qml/ubi/SystemBar.qml \
#    qml/ubi/TaskBar.qml \
#    qml/ubi/DownloadProgressBar.qml \
#    qml/ubi/components/DialogYesNo.qml
#}

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_fremantle/rules \
    qtc_packaging/debian_fremantle/README \
    qtc_packaging/debian_fremantle/copyright \
    qtc_packaging/debian_fremantle/control \
    qtc_packaging/debian_fremantle/compat \
    qtc_packaging/debian_fremantle/changelog

HEADERS += \
    utils.h

TRANSLATIONS += translations/ubi.pl.ts

RESOURCES += \
    ubi.qrc
