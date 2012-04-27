import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root

    state: "idle"

    signal clicked()

    onStateChanged: {
        if(root.state=="busy") {
            animationIcon.start();
        } else {
            animationIcon.stop();
        }
    }

    Rectangle {
        id: mask
        anchors.fill: root
        color: "black"
        opacity: 0

        Text {
            id: label
            color: Const.DEFAULT_FOREGROUND_COLOR
            anchors.centerIn: parent
            font.pixelSize: Const.DEFAULT_FONT_PIXEL_SIZE
        }

        Image {
            id: icon
            width: 64
            height: 64
            anchors.centerIn: parent
            source: "../images/progress.png"
            sourceSize.width: width
            sourceSize.height: height
            visible: root.state=="busy"

            NumberAnimation {
                id: animationIcon
                target: icon
                properties: "rotation"
                from: 0
                to: 360
                duration: 500
                loops: Animation.Infinite
            }
        }

        MouseArea {
            id: maskMouseArea
            anchors.fill: parent
            enabled: root.state=="defocused"
            onClicked: {
                root.clicked();
            }
        }
    }

    states: [
        State {
            name: "defocused"
            PropertyChanges { target: mask; opacity: 0.6 }
        },
        State {
            name: "idle"
            PropertyChanges { target: mask; opacity: 0 }
            PropertyChanges { target: label; text: "" }
        },
        State {
            name: "busy"
            PropertyChanges { target: mask; opacity: 0.6 }
            PropertyChanges { target: label; text: "" }
        },
        State {
            name: "dialog"
            PropertyChanges { target: mask; opacity: 0.6 }
            PropertyChanges { target: label; text: "" }
        }

    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
    }
}
