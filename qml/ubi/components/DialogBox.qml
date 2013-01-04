import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Showable {
    id: root

    hidden: true
    //easingType: Easing.InOutBounce

    anchors.left: parent.left; anchors.right: parent.right
    height: parent.height-Const.SYSTEM_BAR_HEIGHT+Const.SHADOW_OFFSET

    signal opened()
    signal canceled()

    function open() {
        root.forceActiveFocus();
        root.show();
        root.opened();
        topbar.hide();
        systemBar.state = "inactive";
        pageStack.currentPage.mask.state = "dialog";
    }

    function close() {
        if(state!="closed") {
            root.hide();
            topbar.show();
            systemBar.state = "active";
            pageStack.currentPage.mask.state = "idle";
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.canceled();
            root.close();
        }
    }
}

