import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const


Item {
    id: root
    property alias name: label.text
    property bool isDirectory: false
    property variant properties: null
    property string filename: ""
    property int textMax: 27

    state: mouseArea.pressed && !root.disabled ? "pressed" : "unpressed"

    width: box.width
    height: box.height

    signal clicked(variant prop)

    Rectangle {
        id: shadow
        width: box.width
        height: box.height
        color: Const.SHADOW_COLOR;
        radius: 10
        x: Const.SHADOW_OFFSET;
        y: Const.SHADOW_OFFSET;
    }

    Rectangle {
        id: box
        color: root.isDirectory ? "black" : "white"
        height: label.height+20
        width: label.width<=100 ? 120 : label.width+20
        radius: 10
    }

    Rectangle {
        width: box.width
        height: box.height
        x: box.x
        y: box.y
        color: root.isDirectory ? "white" : "black"
        opacity: 0.5
        radius: 10
        visible: mouseArea.pressed
    }

    Text {
        id: label
        x: 10
        y: 10
        font.pixelSize: 30
        color: root.isDirectory ? "white" : "black"
        elide: Text.ElideLeft
        anchors.centerIn: box
        wrapMode: Text.Wrap
        onTextChanged: {
            if(text.length>root.textMax)
                root.name = text.substring(0,root.textMax-3)+"...";
        }
    }

    MouseArea {
        id: mouseArea
        width: box.width
        height: box.height
        onClicked: {
            root.clicked(root.properties);
        }
    }

    states: [
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
    ]
}
