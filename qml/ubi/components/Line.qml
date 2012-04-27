import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root
    height: 10
    Rectangle {
        color: Const.DEFAULT_FOREGROUND_COLOR
        height: 2
        width: root.width
        anchors.bottom: root.bottom
    }
}
