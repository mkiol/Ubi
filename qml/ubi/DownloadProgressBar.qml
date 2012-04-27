import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "UIConstants.js" as Const

Rectangle {
    id: root
    height: 20
    width: 200
    state: "invisible"
    color: Const.TRANSPARENT
    border.width: 1
    radius: 5
    border.color: Const.DEFAULT_FOREGROUND_COLOR

    Rectangle {
        id: bar
        height: parent.height
        width: root.width/2
        x:0
        radius: 5
        color: Const.DEFAULT_FOREGROUND_COLOR
        state: "right"

        states: [
            State {
                name: "right"
            },
            State {
                name: "left"
            },
            State {
                name: "progress"
            }
        ]
    }

    function setProgres(progress) {
        //console.log("proggress = "+progress);
        if(bar.state!="progress") {
            time.stop();
            bar.state = "progress"
            bar.x=0;
        }
        bar.width = root.width*progress;
        if(progress==1)
            stopDownload();
    }
    function startDownload() {
        //console.log("start download");
        bar.width=root.width/2;
        bar.x=0;
        state = "visible";
        time.restart();
    }
    function stopDownload() {
        //console.log("stop download");
        state = "invisible";
    }

    Timer {
        id: time
        interval: 10
        repeat: true
        onTriggered: {
            if(bar.x+bar.width>=root.width)
                bar.state = "left";
            if(bar.x<=0)
                bar.state = "right";

            if(bar.state=="right")
                bar.x += 6;
            else if(bar.state=="left")
                bar.x -= 6;
        }
    }

    states: [
        State {
            name: "visible"
            PropertyChanges { target: root; opacity: 1 }
        },
        State {
            name: "invisible"
            PropertyChanges { target: root; opacity: 0 }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
    }
}
