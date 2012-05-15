import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
//import "../UIConstants.js" as Const

Item {
    id: root

    property bool hidden: false
    property int easingType: Easing.InOutCubic
    property int speed: 1

    state: hidden ? "closed" : "opened"
    //visible: !hidden

    Component.onCompleted: {
        if(hidden) state = "closed";
    }

    function show() {
        root.state = "opened";
    }

    function hide() {
        root.state = "closed";
    }

    states: [
        State {
            name: "opened"
            PropertyChanges { target: root; y: 0}
            PropertyChanges { target: root; visible: true }
        },
        State {
            name: "closed"
            PropertyChanges { target: root; y: root.height }
            //PropertyChanges { target: root; visible: false }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "y"; easing.type: root.easingType;
            duration: root.speed*root.height/2;
        }
    }

    onStateChanged: {
        if(state=="closed") time.start()
    }

    Timer {
        id: time
        interval: root.speed*root.height/2
        onTriggered: {
            //console.log("aaa");
            root.visible = false;
        }
    }

}
