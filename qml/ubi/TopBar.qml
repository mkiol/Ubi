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

    Rectangle {
        id: box
        width: 50
        height: width
        radius: 5
        color: mouseArea.pressed ? "white" : "black"
        opacity: 0.2
        x: -width/2
        y: -width/2

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: Utils.minimizeWindow()
        }
    }

    Rectangle {
        width: box.width/2-16
        height: 2
        color: "white"
        x: 8
        y: (box.width/4)-1
    }

    /*Rectangle {
        width: parent.width
        height: root.height
        color: Const.TRANSPARENT
        //color: "black"
    }

    Item {
        id: minimizeButton
        width: 80;
        height: 60
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; margins: 5 }

        Rectangle {
            id: background
            anchors { fill: parent; margins: 6 }
            color: "black"
            opacity: 0.2
            radius: 10
        }

        Rectangle {
            anchors { fill: parent; margins: 6 }
            color: "white"
            opacity: 0.5
            radius: 10
            visible: mouseArea.pressed
        }

        Image {
            id: icon
            anchors.centerIn: parent
            source: "images/minimize.png"
            sourceSize.width: width
            sourceSize.height: height
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: Utils.minimizeWindow()
        }
    }*/

    /*ToolIcon {
        id: backButton
        width: 80
        anchors { verticalCenter: parent.verticalCenter; right: parent.right; margins: 5 }
        iconSource: "images/close.png"
        onClicked: Qt.quit()
    }*/

}




