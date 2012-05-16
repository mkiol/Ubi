import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const

Item {
    id: root

    height: Const.SYSTEM_BAR_HEIGHT
    anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
    state: "active"

    signal clicked()
    signal clickedOnMask()

    /*Shadow {
        id: shadow
        y:0
        visible: false
    }*/

    /*Rectangle {
        id: bor
        color: Const.WARM_GREY_COLOR
        //color: Const.TRANSPARENT
        height: 2; width: root.width
        anchors.top: box.top
    }*/

    Rectangle {
        id: box
        width: root.width
        height: root.height
        y:3
        color: Const.TRANSPARENT
        //color: Const.COOL_GREY_COLOR
        gradient: Gradient {
            GradientStop {position: 0.0; color: "#333333"}
            GradientStop {position: 1.0; color: "#151515"}
        }
    }

    /*Row {
        id: box
        y: 3
        Repeater {
            model: root.width
            Image {
                id: img
                source: "images/bg.png"
            }
        }
    }*/

    Shadow {
        anchors.bottom: box.top
    }

    Row {
        y: 12
        anchors {horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter}
        spacing: Const.DEFAULT_MARGIN

        Text {
            id: title
            font.pixelSize: 30
            color: "white"
            text: pageStack.currentPage.title
        }

        /*Image {
            source: mouse.pressed? "images/menu-arrow-grey.png" : "images/menu-arrow.png"
            anchors.verticalCenter: title.verticalCenter
            visible: !taskBar.isEmpty && !progressIcon.visible
            width: 18
            height: 14
        }*/

        Image {
            id: progressIcon
            source: "images/progress-small.png"
            anchors.verticalCenter: title.verticalCenter
            visible: downloadDialog.isActiveDownloads
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

    /*ToolIcon {
        id: minimizeButton

        width: 80
        anchors { verticalCenter: parent.verticalCenter; left: parent.left }
        iconSource: "images/minimize.png"
        onClicked: Utils.minimizeWindow()
    }*/

    Button {
        id: minimizeButton
        iconSource: pageStack.index > 0 ?  "images/back.png" : "images/close.png"
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; margins: Const.DEFAULT_MARGIN }
        onButtonClicked: pageStack.index > 0 ? pageStack.pop() : Qt.quit()
    }

    /*Button {
        id: switchButton
        label: "s"
        anchors { verticalCenter: parent.verticalCenter; left: minimizeButton.right; margins: Const.DEFAULT_MARGIN }
        onButtonClicked: {
            tip.show("ala ma kota, a kot ma Ale bardzo czesto i bardzo dobrze, oooo, tralalal!");
        }
    }*/

    Button {
        id: downloadButton
        iconSource: "images/upload.png"
        anchors { verticalCenter: parent.verticalCenter; right: menuButton.left; margins: Const.DEFAULT_MARGIN }
        onButtonClicked: downloadDialog.open()
        opacity: downloadDialog.isActiveDownloads ? 1 : 0

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 600; easing.type: Easing.InOutQuad }
        }
    }

    Button {
        id: menuButton
        iconSource: "images/options.png"
        anchors { verticalCenter: parent.verticalCenter; right: parent.right; margins: Const.DEFAULT_MARGIN }
        onButtonClicked: pageStack.currentPage.taskMenu.open()
        visible: pageStack.currentPage.taskMenu!=undefined
    }

    MouseArea {
        anchors.fill: parent
        z: -1
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        color: "black"

        MouseArea {
            anchors.fill: parent
            onClicked: root.clickedOnMask()
        }
    }

    states: [
        State {
            name: "active"
            PropertyChanges { target: mask; opacity: 0 }
        },
        State {
            name: "inactive"
            PropertyChanges { target: mask; opacity: 0.6 }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
    }

}




