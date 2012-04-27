import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

DialogBox {
    id: root

    property alias text: text.text
    signal closed(string option)

    Rectangle {
        id: box
        anchors.left: root.left; anchors.right: root.right
        height: column.height
        anchors.bottom: root.bottom
        color: Const.LIGHT_AUBERGINE_COLOR

        MouseArea {
            anchors.fill: parent
        }

        Column {
            id: column
            spacing: Const.DEFAULT_MARGIN
            x: 2*Const.DEFAULT_MARGIN
            Spacer {}
            Text {
                id: text
                color: Const.DEFAULT_DIALOG_FOREGROUND_COLOR
                font.pixelSize: Const.DEFAULT_FONT_PIXEL_SIZE
            }
            Row {
                spacing: Const.DEFAULT_MARGIN
                Button {
                    label: "English"
                    onButtonClicked: {
                        root.close();
                        root.closed("en_US");
                    }
                }
                Button {
                    label: "Polski"
                    onButtonClicked: {
                        root.close();
                        root.closed("pl_PL");
                    }
                }
            }
            Spacer {}
        }
    }

    Rectangle {
        anchors.right: root.right; anchors.left: root.left
        anchors.bottom: box.top
        height: Const.SHADOW_OFFSET
        color: "black"
        opacity: 0.5
    }
}
