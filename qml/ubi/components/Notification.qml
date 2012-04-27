import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import Qt 4.7
//import QtMultimediaKit 1.1
import "../UIConstants.js" as Const

Item {
    id: root
    state: "invisible"
    width: box.width; height: box.height

    Rectangle {
        width: box.width
        height: box.height
        color: Const.SHADOW_COLOR;
        radius: 10
        x: 2*Const.SHADOW_OFFSET;
        y: 2*Const.SHADOW_OFFSET;
    }

    Rectangle {
        id: box
        width: text.width+30
        height: text.height+30
        color: Const.DEFAULT_DIALOG_FOREGROUND_COLOR
        radius: 10
        border.color: Const.WARM_GREY_COLOR
        border.width: 4

        Text {
            anchors.centerIn: parent
            id: text
            color: Const.DEFAULT_BACKGROUND_COLOR
            font.pixelSize: Const.DEFAULT_FONT_PIXEL_SIZE
        }

        MouseArea {
            anchors.fill: parent
            onClicked: tip.state = "invisible"
        }
    }

    function show(_text)
    {
        text.text= _text;
        state = "visible"
        //sound.play();
        time.restart();
    }

    function hide()
    {
        text.text="";
        state="invisible";
    }

    /*Audio {
         id: sound
         source: "../sound/message.wav"
    }*/

    Timer {
        id: time
        interval: 3000
        onTriggered: {
            //console.log("time");
            tip.state = "invisible";
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
            PropertyChanges { target: root; x: 0 }
            PropertyChanges { target: root; y: 0 }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
        NumberAnimation { properties: "x"; easing.type: Easing.InOutQuad }
        NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad }
    }

}
