import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "UIConstants.js" as Const
import "components"

Item {
    id: root
    property string title: ""
    property string orientation: Const.DEFAULT_ORIENTATION
    property variant menu
    property alias mask: _mask

    anchors.fill: parent

    Rectangle {
        anchors.right: parent.right
        anchors.left: parent.left
        height: parent.height
        y: Const.SYSTEM_BAR_HEIGHT
        color: Const.DEFAULT_BACKGROUND_COLOR
    }

    Mask {
        id: _mask
        z: 100
        anchors.fill: parent
        onClicked: taskBar.close()
    }

    /*Component.onCompleted: {
        //Utils.setOrientation(orientation);
    }*/
}
