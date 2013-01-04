import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

DialogBox {
    id: root

    property alias label: text.text
    property alias placeholderText: input.placeholderText
    property string text
    property alias textWidth: input.width

    signal closed(string resp)

    function reset() {
        input.text = "";
    }

    onClosed: input.closeSoftwareInputPanel()
    onCanceled: input.closeSoftwareInputPanel()

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
            anchors.horizontalCenter: parent.horizontalCenter
            Spacer {}

            Text {
                id: text
                color: Const.DEFAULT_DIALOG_FOREGROUND_COLOR
                font.pixelSize: Const.DEFAULT_FONT_PIXEL_SIZE
            }

            TextField {
                id: input
            }

            Row {
                spacing: Const.DEFAULT_MARGIN
                Button {
                    label: "Ok"
                    onButtonClicked: {
                        root.close();
                        root.closed(input.text);
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
