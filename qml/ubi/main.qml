import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import Qt 4.7
import "UIConstants.js" as Const

Rectangle {
    id: mainWindow

    width: 480
    height: 800

    color: Const.DEFAULT_BACKGROUND_COLOR

    PageStack {
        id: pageStack
        initialPage: Qt.resolvedUrl("StartPage.qml")
    }

    SystemBar {
        id: systemBar
        onClicked: {
            var mask = pageStack.currentPage.mask;
            if(mask.state=="idle") {
                taskBar.open();
            }
        }
    }

    Notification {
        id: tip
        x: (mainWindow.width-width)/2
        y: 120
    }

    TaskBar {
        id: taskBar
    }

    Connections {
        target: Utils
        onFileDownloaded: tip.show(qsTr("File downloaded!"))
        onFileUploaded: tip.show(qsTr("File uploaded!"))
        onDownloadError: tip.show(qsTr("Error while downloading!"))
        onUploadError: tip.show(qsTr("Error while uploading!"))
        onDownloadAdded: tip.show(qsTr("File added to the queue!"))
        onUploadAdded: tip.show(qsTr("File added to the queue!"))
    }

    Rectangle {
        color: "black"
        width: 1
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

}
