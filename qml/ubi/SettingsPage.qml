import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const

Page {
    id: root
    title: qsTr("Settings")

    Component.onCompleted: {
        var _lang = Utils.locale();
        if(_lang=="pl_PL") {
            lang.text = "Polski";
        } else {
            lang.text = "English";
        }
        login.text = Utils.name();
    }

    Flickable {
        width: root.width
        height: root.height
        contentHeight: content.height+Const.SYSTEM_BAR_HEIGHT+Const.TEXT_MARGIN
        y: Const.SYSTEM_BAR_HEIGHT+Const.TEXT_MARGIN

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
                    pageStack.pop();
                    pageStack.currentPage.init();
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
}
