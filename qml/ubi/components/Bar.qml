import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root

    property string label
    property bool isDownload: false
    property bool isUpload: false
    height: 32

    Image {
        id: icon
        width: root.height
        height: root.height
        source: isDownload? "../"+Const.ICON_DOWN : (isUpload? "../"+Const.ICON_UP : "")
        sourceSize.width: width
        sourceSize.height: height
        visible: isDownload || isUpload
    }

    Rectangle {
        id: bbar

        color: Const.TRANSPARENT
        border.width: 2
        radius: 5
        border.color: Const.DEFAULT_FOREGROUND_COLOR
        height: root.height
        width: icon.visible? root.width-icon.width-5 : root.width
        x: icon.visible? icon.width+5 : 0

        Rectangle {
            id: bar
            height: parent.height
            width: 0
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

        Text {
            id: caption
            font.pixelSize: 25
            anchors.centerIn: parent
            //color: Const.DEFAULT_FOREGROUND_COLOR
            text: root.label.length>28 ? root.label.substring(0,25)+"..." : root.label
            color: "black"
        }

    }

    function setProgres(progress) {
        console.log("proggress = "+progress);
        if(bar.state!="progress") {
            time.stop();
            bar.state = "progress"
            bar.x=0;
        }
        bar.width = bbar.width*progress;
        if(progress==1)
            stop();
    }

    function start() {
        bar.width=bbar.width/2;
        bar.x=0;
        time.restart();
    }

    function stop() {
        //console.log("stop!");
    }

    Timer {
        id: time
        interval: 10
        repeat: true
        onTriggered: {
            if(bar.x+bar.width>=bbar.width)
                bar.state = "left";
            if(bar.x<=0)
                bar.state = "right";

            if(bar.state=="right")
                bar.x += 6;
            else if(bar.state=="left")
                bar.x -= 6;
        }
    }
}

