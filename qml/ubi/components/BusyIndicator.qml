import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
//import "../UIConstants.js" as Const

Image {
    id: icon

    property bool running: false

    width: 64
    height: 64

    source: "../images/progress.png"
    sourceSize.width: width
    sourceSize.height: height

    Component.onCompleted: {
        if(running) animation.start();
    }

    onRunningChanged: {
        if(running) {
            animation.start();
        } else {
            animation.stop();
        }
    }

    NumberAnimation {
        id: animation
        target: icon
        properties: "rotation"
        from: 0
        to: 360
        duration: 500
        loops: Animation.Infinite
    }
}
