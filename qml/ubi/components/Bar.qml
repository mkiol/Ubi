import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root

    property string label
    property bool isDownload: false
    property bool isUpload: false
    height: button.height
    //width: parent.width

    width: mainWindow.width-3*Const.DEFAULT_MARGIN

    signal cancel(string file);

    Row {
        spacing: Const.DEFAULT_MARGIN
        anchors.verticalCenter: parent.verticalCenter

        Image {
            id: icon
            source: isDownload? "../images/download.png" :
                    isUpload? "../images/upload.png" : ""
            visible: isDownload || isUpload
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            id: bbar
            anchors.verticalCenter: parent.verticalCenter
            color: Const.TRANSPARENT
            border.width: 2
            border.color: Const.DEFAULT_FOREGROUND_COLOR
            height: 40
            width: icon.visible?
                       root.width-icon.width-button.width-2*Const.DEFAULT_MARGIN :
                       root.width-button.width-1*Const.DEFAULT_MARGIN

            Rectangle {
                id: bar
                height: parent.height
                width: 0
                x:0
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
                text: root.label
                width: bbar.width
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                color: "black"
            }
        }

        Button {
            id: button
            anchors.verticalCenter: parent.verticalCenter
            iconSource: "images/close.png"
            onButtonClicked: root.cancel(root.label)
        }
    }

    function setProgres(progress) {
        //console.log("proggress = "+progress);
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

