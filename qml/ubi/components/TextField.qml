import QtQuick 1.0

Rectangle {
    id: root

    property alias text : input.text
    property alias echoMode : input.echoMode
    property alias inputFocus: input.focus
    property alias placeholderText: placeholder.text

    signal textChanged

    height: 50

    color:  "white"
    border.width: 3
    border.color: input.activeFocus ? "black" : "grey"

    function closeSoftwareInputPanel() {
        input.focus = false;
        input.closeSoftwareInputPanel();
    }

    TextInput {
        id: input

        anchors { fill: parent; leftMargin: 6; rightMargin: 6; topMargin: 6; bottomMargin: 6 }
        font.pixelSize: 30
        selectByMouse: true
        selectionColor: "gray"
        onTextChanged: root.textChanged()
        //focus: true

        Keys.onPressed: {
            if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                closeSoftwareInputPanel();
                focus = false;
                dummy.focus = true;
            }
        }

        onFocusChanged: {
            if(focus == false) {
                closeSoftwareInputPanel();
            }
        }

    }
    Item { id: dummy }

    Text {
        id: placeholder

        anchors { fill: parent; leftMargin: 6; rightMargin: 6; topMargin: 6; bottomMargin: 6 }
        font.pixelSize: input.font.pixelSize
        clip: true
        visible: (!input.activeFocus) && (input.text == "")
        color: "gray"
        font.italic: true
    }

}
