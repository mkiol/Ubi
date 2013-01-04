import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root
    property alias text: textbox.text
    property bool disabled: false
    property int fontSize: 30
    property string iconSource

    state: mouseArea.pressed && !root.disabled ? "pressed" : "unpressed"

    signal clicked(string label)

    Rectangle {
        id: shadow
        width: box.width
        height: box.height
        color: Const.SHADOW_COLOR;
        radius: 10
    }

    Rectangle {
        id: box
        color: root.disabled ? Const.COOL_GREY_COLOR : "black"
        height: root.height
        width: root.width
        radius: 10
    }

    Rectangle {
        width: box.width
        height: box.height
        x: box.x
        y: box.y
        color: Const.WARM_GREY_COLOR
        radius: 10
        visible: root.state == "pressed"
    }

    Image {
        id: icon
        width: 40
        height: 40
        anchors.centerIn: box
        source: root.iconSource == "" ? "" : "../" + root.iconSource
        sourceSize.width: width
        sourceSize.height: height
    }

    Text {
        id: textbox
        font.pixelSize: root.fontSize
        elide: Text.ElideRight
        color: root.disabled ? "gray" : "white"
        anchors.left: box.left; anchors.right: box.right
        anchors.margins: Const.DEFAULT_MARGIN
        anchors.verticalCenter: box.verticalCenter
    }

    MouseArea {
        id: mouseArea
        width: box.width
        height: box.height
        onClicked: root.clicked(root.label)
        enabled: !root.disabled
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



