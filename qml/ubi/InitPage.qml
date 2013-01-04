import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "UIConstants.js" as Const
import "u1.js" as U1
import "components"

Showable {
    id: root

    hidden: false

    Component.onCompleted: init()

    function init() {
        if(Utils.isAuthorized()) {
            //title = "Hi, "+Utils.name();
            login();
        } else {
            pageStack.initialPage = "LoginPage.qml";
            hide();
        }
    }

    function login() {
        pageStack.currentPage.init();
    }

    function onRespRootNode(resp) {
        hide();
    }

    function onErr(status) {
        if(status==401) {
            hide()
            tip.show(qsTr("Ubuntu One authorization has failed. Try once again or check login settings."));
        } else if(status==0) {
            hide()
            tip.show(qsTr("Unable to connect. Check internet connection and restart application."));
        } else {
            hide()
            tip.show(qsTr("Unknown error: ")+status);
        }
    }

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: box

        width: root.width; height: root.height
        color: Const.DEFAULT_BACKGROUND_COLOR

        Column {
            spacing: Const.TEXT_MARGIN
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: pic
                source: "images/ubi100.png"
                width: 104; height: 70
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: loading
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 25
                color: "white"
                text: qsTr("Connecting...")
            }

            BusyIndicator {
                id: busy
                anchors.horizontalCenter: parent.horizontalCenter
                running: true
            }
        }

        Button {
            id: close
            iconSource: "images/close.png"
            anchors { right: parent.right; top: parent.top; margins: Const.DEFAULT_MARGIN }
            onButtonClicked: Qt.quit()
        }

        Text {
            anchors.bottom: ver.top
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 20
            color: "white"
            text: "v0.9.4-1 © 2012 Michal Kosciesza"
        }

        Text {
            id: ver
            anchors.bottom: box.bottom
            anchors.bottomMargin: 2*Const.TEXT_MARGIN
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 20
            color: "white"
            text: "http://ubi.garage.maemo.org"
        }

    }
}
