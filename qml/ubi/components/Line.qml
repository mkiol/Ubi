import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root
    height: 10

    Row {
        anchors.bottom: root.bottom
        width: root.width
        spacing: 5
        Repeater {
            model: root.width/6
            Rectangle {
                color: Const.DEFAULT_FOREGROUND_COLOR
                height: 2
                width: 1
            }
        }
    }

    /*Rectangle {
        y:0
        color: "black"
        height: 1
        width: root.width
        opacity: 0.5
        //anchors.bottom: root.bottom
    }
    Rectangle {
        y:3
        color: "black"
        height: 1
        width: root.width
        opacity: 0.2
        //anchors.bottom: root.bottom
    }*/
}
