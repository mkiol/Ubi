import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const

Item {
    id: root

    property bool isEmpty: progressArea.count==0 && menu.children.length==0
    property bool isActiveDownloads: progressArea.count>0

    width: mainWindow.width
    height: items.height + 3*Const.DEFAULT_MARGIN
    state: "closed"

    function open() {
        if(progressArea.count>0 || menu.children.length>0) {
            state = "opened";
            pageStack.currentPage.mask.state = "defocused";
        }
    }

    function close() {
        state = "closed"
        pageStack.currentPage.mask.state = "idle";
    }

    function addTask(filename) {
        progress.addTask(filename);
    }

    function getMenu() {
        return menu;
    }

    function fixHeight() {
        root.height = items.height + 3*Const.DEFAULT_MARGIN;
    }

    Rectangle {
        id: box
        width: parent.width
        height: parent.height
        y: 0
        color: Const.LIGHT_AUBERGINE_COLOR

        MouseArea {
            anchors.fill: parent
        }
    }

    Shadow {
        y: box.height
    }

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
    }

    Column {
        id: items
        y: Const.DEFAULT_MARGIN
        width: root.width-2*Const.DEFAULT_MARGIN
        spacing: Const.DEFAULT_MARGIN
        anchors.horizontalCenter: box.horizontalCenter

        Flow {
            id: menu
            width: parent.width
            spacing: Const.DEFAULT_MARGIN
        }

        Spacer {
            visible: progressArea.count>0
        }

        DownloadArea {
            id: progressArea
            width: root.width-3*Const.DEFAULT_MARGIN
        }

    }

    states: [
        State {
            name: "opened"
            PropertyChanges { target: root; opacity: 1 }
            PropertyChanges { target: root; y: 0}
        },
        State {
            name: "closed"
            PropertyChanges { target: root; opacity: 0 }
            PropertyChanges { target: root; y: 0-root.height }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
        NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad }
        NumberAnimation { properties: "height"; easing.type: Easing.InOutQuad }
    }

}
