import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root

    property string iconSource
    property bool pressed: mouseArea.pressed
    property string color: Const.TRANSPARENT

    signal clicked
    signal pressAndHold

    width: 56
    height: 56

    Rectangle {
        id: background
        anchors { fill: parent; margins: 6 }
        //color: root.color
        color: "black"
        opacity: 0.1
        radius: 10
    }

    Rectangle {
        anchors { fill: parent; margins: 6 }
        color: "white"
        opacity: 0.5
        radius: 10
        visible: mouseArea.pressed
    }

    Image {
        id: icon
        width: 30
        height: 30
        anchors.centerIn: parent
        source: iconSource == "" ? "" : "../" + iconSource
        sourceSize.width: width
        sourceSize.height: height
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        enabled: root.enabled
        onClicked: parent.clicked()
        onPressAndHold: parent.pressAndHold()
    }
}
