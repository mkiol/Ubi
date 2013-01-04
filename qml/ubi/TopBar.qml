import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const

Item {
    id: root

    height: Const.TOP_BAR_HEIGHT
    anchors { left: parent.left; right: parent.right; top: top.bottom }

    function hide() {
        visible = false;
    }

    function show() {
        visible = true;
    }

    Item {
        width: 50
        height: width
        anchors.left: root.left

        MouseArea {
            id: mouseArea1
            anchors.fill: parent
            onClicked: Utils.minimizeWindow()
        }
    }

    Item {
        width: 50
        height: width
        anchors.right: root.right

        MouseArea {
            id: mouseArea2
            anchors.fill: parent
            onClicked: Qt.quit()
        }
    }
}




