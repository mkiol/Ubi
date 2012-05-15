import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root

    state: "invisible"

    //width: box.width
    height: box.height

    Rectangle {
        width: box.width
        height: box.height
        color: Const.SHADOW_COLOR;
        radius: 5
        x: 2*Const.SHADOW_OFFSET;
        y: 2*Const.SHADOW_OFFSET;
    }

    Rectangle {
        id: box
        height: text.height+4*Const.DEFAULT_MARGIN
        width: root.width
        //color: Const.DEFAULT_DIALOG_FOREGROUND_COLOR
        color: Const.COOL_GREY_COLOR
        radius: 5

        border.color: Const.WARM_GREY_COLOR
        border.width: 1

        Text {
            id: text
            anchors.centerIn: parent
            anchors.margins: Const.DEFAULT_MARGIN
            color: Const.DEFAULT_FOREGROUND_COLOR
            wrapMode: Text.WordWrap
            font.pixelSize: Const.DEFAULT_FONT_PIXEL_SIZE
            width: parent.width-2*Const.DEFAULT_MARGIN
            horizontalAlignment: Text.Center
        }

        MouseArea {
            anchors.fill: parent
            onClicked: tip.state = "invisible"
        }
    }

    function show(_text)
    {
        text.text= _text;
        if(_text.length > 40) {
            time.interval = _text.length*100;
        } else {
            time.interval = 3000;
        }
        state = "visible"
        time.restart();
    }

    function show2(_text,interval)
    {
        text.text= _text;
        time.interval = interval;
        state = "visible"
        time.restart();
    }

    function hide()
    {
        text.text="";
        state="invisible";
    }

    Timer {
        id: time
        interval: 3000
        onTriggered: {
            tip.state = "invisible";
        }
    }

    states: [
        State {
            name: "visible"
            PropertyChanges { target: root; opacity: 1 }
            PropertyChanges { target: root; width: mainWindow.width-2*Const.TEXT_MARGIN }
            PropertyChanges { target: text; font.pixelSize: Const.DEFAULT_FONT_PIXEL_SIZE }
        },
        State {
            name: "invisible"
            PropertyChanges { target: root; width: 0 }
            PropertyChanges { target: text; font.pixelSize: 1 }
            PropertyChanges { target: root; opacity: 0 }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutBack }
        NumberAnimation { properties: "width"; easing.type: Easing.InOutBack}
        NumberAnimation { properties: "font.pixelSize"; easing.type: Easing.InOutBack}
    }

}
