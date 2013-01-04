import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root
    height: 2

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
}
