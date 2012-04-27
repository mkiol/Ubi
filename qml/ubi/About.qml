import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "UIConstants.js" as Const

Item {
    id: root
    anchors.right: parent.right
    anchors.left: parent.left

    Rectangle {
        anchors.right: parent.right
        anchors.left: parent.left

        height: Const.SHADOW_OFFSET
        color: "black"
        opacity: 0.4

        /*height: Const.SYSTEM_BAR_HEIGHT + 3
        y: 0
        gradient: Gradient {
            GradientStop { position: 0.9; color: "black" }
            GradientStop { position: 1.0; color: Const.TRANSPARENT }
        }*/
    }
}
