import QtQuick 1.1
import "components"
import "UIConstants.js" as Const
import com.nokia.meego 1.0 as Meego

Meego.PageStackWindow {
    id: appWindow

    initialPage: mainPage
    showToolBar: false
    //showStatusBar: false

    Component.onCompleted: {
        theme.inverted = true;
    }

    Meego.Page {
        id: mainPage

        Rectangle {
            id: mainWindow

            anchors.fill: parent
            color: Const.DEFAULT_BACKGROUND_COLOR

            PageStack {
                id: pageStack
                initialPage: Qt.resolvedUrl("FilesPage.qml")
            }

            TopBar {
                id: topbar
            }

            NotificationNew {
                id: tip
                z: 201
                anchors.horizontalCenter: mainWindow.horizontalCenter
                y: mainWindow.height-height-Const.SYSTEM_BAR_HEIGHT-Const.TEXT_MARGIN
            }

            Connections {
                target: Utils
                onFileDownloaded: tip.show(qsTr("File downloaded."))
                onFileUploaded: tip.show(qsTr("File uploaded."))
                onDownloadError: tip.show(qsTr("Error while downloading."))
                onUploadError: tip.show(qsTr("Error while uploading."))
                onDownloadAdded: tip.show(qsTr("File added to the queue."))
                onUploadAdded: tip.show(qsTr("File added to the queue."))
                onOperationCanceled: tip.show(qsTr("File operation canceled."))
            }

            DialogBlank {
                id: downloadDialog
                z: 200

                property bool isActiveDownloads: progressArea.count>0

                boxHeight: progressArea.height + 3*Const.DEFAULT_MARGIN

                Connections {
                    target: Utils
                    onFileDownloadProgress: progressArea.setProgress(filename,progress)
                    onFileUploadProgress: progressArea.setProgress(filename,progress)
                    onDownloadAdded: progressArea.addTask("download",filename)
                    onUploadAdded: progressArea.addTask("upload",filename)
                    onDownloadStarted: progressArea.start(filename)
                    onUploadStarted: progressArea.start(filename)
                    onFileDownloaded: progressArea.stop(filename)
                    onFileUploaded: progressArea.stop(filename)
                    onDownloadError: progressArea.stop(filename)
                    onUploadError: progressArea.stop(filename)
                    onOperationCanceled: progressArea.stop(filename)
                    onFileRemovedFromQuee: progressArea.stop(filename)
                }

                DownloadArea {
                    anchors.top: parent.box.top
                    anchors.topMargin: 2*Const.DEFAULT_MARGIN
                    anchors.margins: Const.DEFAULT_MARGIN
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: progressArea
                    width: parent.width-3*Const.DEFAULT_MARGIN
                }
            }

            DialogInfo {
                id: aboutDialog
                z: 200
                fontSize: 28
                iconSource: "images/ubi50.png"
                textHeader: qsTr("<b>Ubi</b>")

                text: qsTr("<p>An unofficial Ubuntu One app for Maemo/Meego "
                      +"and other Qt-enabled platforms.</p>"
                      +"<p><small>http://ubi.garage.maemo.org</small></p>"
                      +"<p><small>© 2012 Michal Kosciesza</small></p>")
            }

            SystemBar {
                id: systemBar
                z: 201
                onClickedOnMask: {
                    aboutDialog.close();
                    downloadDialog.close();
                    pageStack.currentPage.taskMenu.close();
                }
            }

            Rectangle {
                color: "black"
                z: 300
                width: 1
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
            }

            InitPage {
                id: initPage
                z: 301
                height: mainWindow.height;
                width: mainWindow.width;
            }
        }

    }
}
