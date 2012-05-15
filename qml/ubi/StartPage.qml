import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "UIConstants.js" as Const
import "u1.js" as U1
import "components"

Page {
    id: root
    title: "Ubi"

    //Component.onCompleted: init()

    /*function init() {
        if(Utils.isAuthorized()) {
            //title = "Hi, "+Utils.name();
        } else {
            console.log("not authorized!");
            pageStack.initialPage = "LoginPage.qml";
        }
    }*/

    menu: [
        [qsTr("About Ubi"),false]
    ]

    function menuFun(id) {
        if(id==qsTr("About Ubi")) {
            dialog.open();
        }
    }

    Column {
        spacing: 10
        anchors.centerIn: parent

        /*Image {
            source: "images/cloud.png"
            width: 150; height: 98
        }

        Spacer{}
        Spacer{}
        */

        Spacer{}
        Spacer{}

        ButtonNew {
            height: 100; width: 250
            label: qsTr("Files")
            //iconSource: "images/files.png"
            anchors.horizontalCenter: parent.horizontalCenter
            onButtonClicked: {
                pageStack.push("FilesPage.qml");
                pageStack.currentPage.init();
            }
        }

        /*Button {
            label: "Contacts"
            disabled: true
        }
        Button {
            label: "Notes"
            disabled: true
        }*/

        ButtonNew {
            height: 100; width: 250
            label: qsTr("Account")
            //iconSource: "images/account.png"
            anchors.horizontalCenter: parent.horizontalCenter
            onButtonClicked: {
                pageStack.push("AccountPage.qml");
            }
        }
        ButtonNew {
            height: 100; width: 250
            label: qsTr("Settings")
            //iconSource: "images/settings.png"
            anchors.horizontalCenter: parent.horizontalCenter
            onButtonClicked: pageStack.push("SettingsPage.qml");
        }
        /*Button {
            label: "Test"
            //onButtonClicked: tip.show("Ala ma kota!")
            //onButtonClicked: dialog.open()
            //onButtonClicked: U1.getAccount()
        }*/

        //Spacer{}

    }

    /*FileDialog {
        z: 200
        hidden: false
        folderOnly: false
    }*/

    DialogInfo {
        id: dialog
        z: 200
        fontSize: 28
        iconSource: "images/ubi50.png"
        textHeader: qsTr("<b>Ubi</b>")

        text: qsTr("<p>An unofficial Ubuntu One app for Maemo 5 "
              +"and other Qt-enabled platforms.</p>"
              +"<p><small>http://ubi.garage.maemo.org</small></p>"
              +"<p><small>© 2012 Michal Kosciesza</small></p>")

        onOpened: mask.state = "dialog"
        onCanceled: mask.state = "idle"
    }
}
