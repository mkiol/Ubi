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
        /*var secrets = {
            token: Utils.token(),
            secret: Utils.tokenSecret(),
            consumer_key : Utils.customerKey(),
            consumer_secret: Utils.customerSecret()
        };
        U1.getRootNode(secrets,root);
        */
        pageStack.currentPage.init();
    }

    function onRespRootNode(resp) {
        hide();
    }

    function onErr(status) {
        hide()
        if(status==401) {
            tip.show(qsTr("Ubuntu One authorization has failed. Try once again or check login settings."));
        } else if(status==0) {
            tip.show(qsTr("Unable to connect. Check internet connection."));
        } else {
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
                //y: (box.height-height)/3
            }

            Text {
                id: loading
                //anchors.top: pic.bottom
                //anchors.margins: Const.TEXT_MARGIN
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 25
                color: "white"
                text: qsTr("Connecting...")
            }

            BusyIndicator {
                //anchors.top: loading.bottom
                //anchors.margins: 2*Const.TEXT_MARGIN
                anchors.horizontalCenter: parent.horizontalCenter
                running: true
            }
        }

        Text {
            anchors.bottom: ver.top
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 20
            color: "white"
            text: "v0.9.3-1 © 2012 Michal Kosciesza"
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
