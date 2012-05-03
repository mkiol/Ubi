import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root
    property alias name: label.text
    property alias description: details.text
    property bool isDirectory: false
    property bool isPhoto: false
    property variant properties: null
    property string filename: ""
    property int textMax: 27

    state: mouseArea.pressed && !root.disabled ? "pressed" : "unpressed"

    //width: box.width
    height: box.height

    signal clicked(variant prop)

    /*Rectangle {
        id: shadow
        width: box.width
        height: box.height
        color: Const.SHADOW_COLOR;
        radius: 10
        x: Const.SHADOW_OFFSET;
        y: Const.SHADOW_OFFSET;
    }*/

    Rectangle {
        id: box
        color: Const.TRANSPARENT
        height: label.height+5*Const.DEFAULT_MARGIN
        width: root.width
    }

    /*Rectangle {
        color: Const.DEFAULT_FOREGROUND_COLOR
        height: 1
        anchors.bottom: box.bottom;
        anchors.left: box.left;
        anchors.right: box.right;
    }*/

    Rectangle {
        id: boxShadow
        width: box.width-2*Const.TEXT_MARGIN+2*Const.DEFAULT_MARGIN
        height: box.height
        y: 5
        //color: root.isDirectory ? "white" : "black"
        color: Const.DEFAULT_DIALOG_FOREGROUND_COLOR
        //anchors.verticalCenter: box.verticalCenter
        anchors.horizontalCenter: box.horizontalCenter
        opacity: 0.4
        radius: 10
        visible: mouseArea.pressed
    }
    /*Line {
        width: boxShadow.width
        anchors.bottom: boxShadow.bottom
        anchors.horizontalCenter: box.horizontalCenter
    }*/


    Image {
        id: icon
        width: 50
        height: 50
        x: Const.TEXT_MARGIN-5
        source: root.isDirectory ? "../images/folder.png" : root.isPhoto ? "../images/photo.png" : "../images/document.png"
        sourceSize.width: width
        sourceSize.height: height
        anchors.verticalCenter: box.verticalCenter
    }

    Text {
        id: label
        x: Const.TEXT_MARGIN + icon.width + 2*Const.DEFAULT_MARGIN
        font.pixelSize: 30
        color: Const.DEFAULT_FOREGROUND_COLOR
        elide: Text.ElideRight
        wrapMode: Text.Wrap
        width: root.width-x-Const.TEXT_MARGIN-2*Const.DEFAULT_MARGIN-arrow.width
        anchors.verticalCenter: box.verticalCenter
    }

    Text {
        id: details
        x: Const.TEXT_MARGIN + icon.width + 2*Const.DEFAULT_MARGIN
        font.pixelSize: 20
        font.italic: true
        color: "black"
        elide: Text.ElideRight
        wrapMode: Text.Wrap
        width: root.width-x-Const.TEXT_MARGIN-2*Const.DEFAULT_MARGIN-arrow.width
        //anchors.bottom: boxShadow.bottom
        y: box.height-height
    }

    Image {
        id: arrow
        width: 30
        height: 30
        anchors.right: box.right
        anchors.margins: Const.TEXT_MARGIN
        source: "../images/next.png"
        sourceSize.width: width
        sourceSize.height: height
        anchors.verticalCenter: box.verticalCenter
    }

    MouseArea {
        id: mouseArea
        width: box.width
        height: box.height
        onClicked: {
            root.clicked(root.properties);
        }
    }

    /*states: [
        State {
            name: "unpressed"
            PropertyChanges {target: shadow; x: Const.SHADOW_OFFSET}
            PropertyChanges {target: shadow; y: Const.SHADOW_OFFSET}
            PropertyChanges {target: box; x: 0}
            PropertyChanges {target: box; y: 0}
        },
        State {
            name: "pressed"
            PropertyChanges {target: shadow; x: Const.SHADOW_OFFSET}
            PropertyChanges {target: shadow; y: Const.SHADOW_OFFSET}
            PropertyChanges {target: box; x: Const.SHADOW_OFFSET}
            PropertyChanges {target: box; y: Const.SHADOW_OFFSET}
        }
    ]*/
}
