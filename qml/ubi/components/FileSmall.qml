import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const


Item {
    id: root
    property alias text: label.text
    property bool isDirectory: false
    property bool isPhoto: false
    property bool isMusic: false
    property bool isVideo: false

    signal clicked()

    height: box.height

    Rectangle {
        id: box
        color: Const.TRANSPARENT
        height: 70
        width: root.width
    }

    Rectangle {
        width: box.width
        height: box.height
        x: box.x; y: box.y
        color: Const.DEFAULT_DIALOG_FOREGROUND_COLOR
        opacity: 0.4
        visible: mouseArea.pressed
    }

    Image {
        id: icon
        width: 40
        height: 40
        source: root.isDirectory ? "../images/folder-small.png" :
                root.isPhoto ? "../images/photo-small.png" :
                root.isMusic ? "../images/music-small.png" :
                root.isVideo ? "../images/video-small.png" : "../images/document-small.png"
        sourceSize.width: width
        sourceSize.height: height
        anchors.left: box.left;
        anchors.verticalCenter: box.verticalCenter
        anchors.margins: Const.TEXT_MARGIN
    }

    Text {
        id: label
        x: 10; y: 10
        font.pixelSize: 30
        color: Const.DEFAULT_DIALOG_FOREGROUND_COLOR
        elide: Text.ElideRight
        anchors.left: icon.right; anchors.right: box.right
        anchors.verticalCenter: box.verticalCenter
        anchors.margins: Const.TEXT_MARGIN
    }

    MouseArea {
        id: mouseArea
        width: box.width
        height: box.height
        onClicked: {
            root.clicked(root.properties);
        }
    }
}
