import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root

    anchors.left: parent.left; anchors.right: parent.right
    height: parent.height
    state: "closed"

    signal opened()
    signal canceled()

    function open() {
        root.forceActiveFocus();
        root.state = "opened";
        root.opened();
    }

    function close() {
        root.state = "closed";
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.canceled();
            root.close();
        }
    }

    states: [
        State {
            name: "opened"
            PropertyChanges { target: root; opacity: 1 }
            PropertyChanges { target: root; y: 0}
        },
        State {
            name: "closed"
            PropertyChanges { target: root; opacity: 0 }
            PropertyChanges { target: root; y: root.height }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
        NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad }
    }
}

