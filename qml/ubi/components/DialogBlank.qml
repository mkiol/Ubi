import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

DialogBox {
    id: root

    property alias boxHeight: _box.height
    property alias box: _box

    Rectangle {
        id: _box
        anchors.left: root.left; anchors.right: root.right
        anchors.bottom: root.bottom
        color: Const.LIGHT_AUBERGINE_COLOR

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.canceled();
                root.close();
            }
        }
    }

    Rectangle {
        anchors.right: root.right; anchors.left: root.left
        anchors.bottom: box.top
        height: Const.SHADOW_OFFSET
        color: "black"
        opacity: 0.5
    }
}
