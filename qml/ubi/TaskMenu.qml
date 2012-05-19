import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const

DialogBlank {
    id: root

    property alias menuHeight: root.boxHeight
    property alias menuFixed: _menuFixed
    property Flow menuDynamic
    property bool contexMenu: false

    onOpened: {
        mask.state = "dialog";
    }
    onCanceled: {
        mask.state = "idle";
    }

    Line {
        id: line
        anchors.top: root.menuDynamic.bottom
        anchors.topMargin: Const.DEFAULT_MARGIN
        width: root.width
        visible: root.contexMenu
    }

    Flow {
        id: _menuFixed

        anchors.top: root.contexMenu ? line.bottom : root.menuDynamic.bottom
        anchors.topMargin: Const.DEFAULT_MARGIN

        x: Const.DEFAULT_MARGIN

        width: root.width-2*Const.DEFAULT_MARGIN
        spacing: Const.DEFAULT_MARGIN

        Button {
            label: qsTr("Account");
            onButtonClicked: {
                taskMenu.close();
                if(pageStack.currentPage.title!=qsTr("Account")) {
                    pageStack.push("AccountPage.qml");
                }
            }
        }

        Button {
            label: qsTr("Settings");
            onButtonClicked: {
                taskMenu.close();
                if(pageStack.currentPage.title!=qsTr("Settings")) {
                    pageStack.push("SettingsPage.qml");
                }
            }
        }

        Button {
            label: qsTr("About Ubi");
            onButtonClicked: {
                taskMenu.close();
                aboutDialog.open();
            }
        }
    }
}
