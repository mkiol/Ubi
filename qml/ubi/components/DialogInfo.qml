import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

DialogBox {
    id: root

    property alias text: text.text
    property alias elide: text.elide
    property alias iconSource: icon.source
    property int fontSize: Const.DEFAULT_FONT_PIXEL_SIZE

    Rectangle {
        id: box
        anchors.left: root.left; anchors.right: root.right
        height: column.height
        anchors.bottom: root.bottom
        color: Const.LIGHT_AUBERGINE_COLOR

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.canceled();
                root.close();
            }
        }

        Column {
            id: column
            spacing: Const.DEFAULT_MARGIN
            x: Const.DEFAULT_MARGIN

            Spacer {}

            Row {
                spacing: Const.DEFAULT_MARGIN
                Image {
                    id: icon
                    width: 50
                    height: 50
                    visible: source!=""
                }

                Text {
                    id: text
                    color: Const.DEFAULT_DIALOG_FOREGROUND_COLOR
                    font.pixelSize: root.fontSize
                    wrapMode: Text.Wrap
                    width: root.width - 6*Const.DEFAULT_MARGIN
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
