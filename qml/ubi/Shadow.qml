import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "UIConstants.js" as Const

Item {
    id: root
    anchors.right: parent.right
    anchors.left: parent.left
    height: Const.SHADOW_OFFSET

    Rectangle {
        anchors.right: parent.right
        anchors.left: parent.left

        height: Const.SHADOW_OFFSET
        color: "black"
        opacity: 0.3
    }
}
