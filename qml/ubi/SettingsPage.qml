import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const

Page {
    id: root
    title: qsTr("Settings")

    property alias taskMenu: taskMenu

    Component.onCompleted: {
        var _lang = Utils.locale();
        if(_lang=="pl_PL")
            lang.text = "Polski";
        if(_lang=="it_IT")
            lang.text = "Italiano";
        if(_lang=="en_US")
            lang.text = "English";

        login.text = Utils.name();
    }

    Flickable {
        width: root.width
        height: root.height

        contentHeight: content.height+Const.TOP_BAR_HEIGHT
                       +Const.SYSTEM_BAR_HEIGHT+Const.TEXT_MARGIN
        y: Const.TOP_BAR_HEIGHT

        Column {
            id: content
            spacing: Const.DEFAULT_MARGIN
            x: Const.TEXT_MARGIN

            Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("Language:")
            }
            Text {
                id: lang
                font.pixelSize: 30
                color: "black"
            }
            Button {
                label: qsTr("Change")
                onButtonClicked: {
                    dialogLang.open();
                }
            }
            Line {
                width: root.width-2*Const.TEXT_MARGIN
            }
            Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("Logged as:")
            }
            Text {
                id: login
                font.pixelSize: 30
                color: "black"
            }
            Button {
                label: qsTr("Log out")
                onButtonClicked: {
                    Utils.resetAuthorization();
                    pageStack.initialPage = "LoginPage.qml";
                    pageStack.clear();
                }
            }
        }

    }

    DialogCombo {
        id: dialogLang
        z: 200
        text: qsTr("Choose language:")
        onOpened: {
            mask.state = "dialog";
        }
        onClosed: {
            mask.state = "idle";
            Utils.setLocale(option);
            tip.show(qsTr("Restart application!"));
        }
        onCanceled: {
            mask.state = "idle";
        }
    }

    TaskMenu {
        z: 200
        id: taskMenu
        menuHeight: menuFixed.height+4*Const.DEFAULT_MARGIN

        menuDynamic: _menuDyn
        Flow {
            y: root.height-taskMenu.menuHeight-Const.SYSTEM_BAR_HEIGHT+1*Const.DEFAULT_MARGIN
            id: _menuDyn
        }
    }
}
