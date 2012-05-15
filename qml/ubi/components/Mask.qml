import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root

    state: "idle"

    signal clicked()

    onStateChanged: {
        if(root.state=="busy") {
            busy.running = true;
        } else {
            busy.running = false;
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

        BusyIndicator {
            id: busy
            anchors.centerIn: parent
            running: true
            visible: root.state=="busy"
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
