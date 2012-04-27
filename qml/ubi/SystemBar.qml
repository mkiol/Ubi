import QtQuick 1.0
import "components"
import "UIConstants.js" as Const

/* copyright (C) 2010-2012 Stuart Howarth */

Item {
    id: root

    height: 60
    anchors { left: parent.left; right: parent.right; top: parent.top }

    signal clicked()



    Rectangle {
        width: parent.width
        height: Const.SYSTEM_BAR_HEIGHT
        color: "black"
    }

    Shadow {
        y: Const.SYSTEM_BAR_HEIGHT
    }

    Row {
        y: 12
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Const.DEFAULT_MARGIN

        Text {
            id: title
            font.pixelSize: 30
            color: "white"
            text: pageStack.currentPage.title
        }

        Image {
            source: mouse.pressed? "images/menu-arrow-grey.png" : "images/menu-arrow.png"
            anchors.verticalCenter: title.verticalCenter
            visible: !taskBar.isEmpty && !progressIcon.visible
            width: 18
            height: 14
        }

        Image {
            id: progressIcon
            source: "images/progress-small.png"
            anchors.verticalCenter: title.verticalCenter
            visible: taskBar.isActiveDownloads
            width: 40
            height: 40

            NumberAnimation {
                id: animationIcon
                target: progressIcon
                properties: "rotation"
                from: 0
                to: 360
                duration: 500
                loops: Animation.Infinite

                Component.onCompleted: animationIcon.start();
            }
        }
    }

    MouseArea {
        id: mouse
        height: root.height
        width: root.height - 2*80
        anchors.horizontalCenter: root.horizontalCenter
        onClicked: root.clicked()
    }

    /*Rectangle {
        id: leftSeparator

        width: 1
        height: 40
        anchors { left: parent.left; leftMargin: 80; verticalCenter: parent.verticalCenter }
        color: "white"
        opacity: 0.5
    }

    Rectangle {
        id: rightSeparator

        width: 1
        height: 40
        anchors { right: parent.right; rightMargin: 80; verticalCenter: parent.verticalCenter }
        color: "white"
        opacity: 0.5
    }*/

    ToolIcon {
        id: minimizeButton

        width: 80
        anchors { verticalCenter: parent.verticalCenter; left: parent.left }
        iconSource: "images/minimize.png"
        onClicked: Utils.minimizeWindow()
    }

    ToolIcon {
        id: backButton

        width: 80
        anchors { verticalCenter: parent.verticalCenter; right: parent.right }
        iconSource: pageStack.index > 0 ?  "images/back.png" : "images/close.png"
        onClicked: pageStack.index > 0 ? pageStack.pop() : Qt.quit()
        onPressAndHold: if (pageStack.index > 0) pageStack.clear()
    }

    MouseArea {
        anchors.fill: parent
        z: -1
    }

}




