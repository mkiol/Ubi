import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "UIConstants.js" as Const
import "u1.js" as U1
import "components"

Rectangle {
    id: root

    color: Const.DEFAULT_BACKGROUND_COLOR
    state: "opened"

    function hide() {
        root.state = "closed";
    }

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
        var secrets = {
            token: Utils.token(),
            secret: Utils.tokenSecret(),
            consumer_key : Utils.customerKey(),
            consumer_secret: Utils.customerSecret()
        };
        U1.getRootNode(secrets,root);
    }

    function onRespRootNode(resp) {
        hide();
    }

    function onErr(status) {
        hide()
        if(status==401) {
            tip.show(qsTr("Authorization failed!"));
        } else if(status==0) {
            tip.show(qsTr("Unable to connect!"));
        } else {
            tip.show(qsTr("Error: ")+status);
        }
    }

    Image {
        id: pic
        source: "images/ubi100.png"
        width: 104; height: 70
        anchors.horizontalCenter: parent.horizontalCenter
        y: (root.height-height)/3
    }

    Text {
        id: loading
        anchors.top: pic.bottom
        anchors.margins: Const.TEXT_MARGIN
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 25
        color: "white"
        text: "Loading..."
    }

    Image {
        id: icon
        width: 64
        height: 64
        anchors.top: loading.bottom
        anchors.margins: 2*Const.TEXT_MARGIN
        source: "images/progress.png"
        sourceSize.width: width
        sourceSize.height: height
        anchors.horizontalCenter: parent.horizontalCenter
        Component.onCompleted: animationIcon.start()

        NumberAnimation {
            id: animationIcon
            target: icon
            properties: "rotation"
            from: 0
            to: 360
            duration: 500
            loops: Animation.Infinite
        }
    }

    Text {
        anchors.bottom: root.bottom
        anchors.bottomMargin: Const.TEXT_MARGIN
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 18
        color: "white"
        text: "ver. 0.9.2-2"
    }

    MouseArea {
        anchors.fill: parent
    }

    states: [
        State {
            name: "opened"
            //PropertyChanges { target: root; opacity: 1 }
            PropertyChanges { target: root; y: 0}
        },
        State {
            name: "closed"
            //PropertyChanges { target: root; opacity: 0 }
            PropertyChanges { target: root; y: root.height }
        }
    ]

    transitions: Transition {
        //NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
        NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad }
    }

}
