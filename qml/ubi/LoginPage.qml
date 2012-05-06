import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "u1.js" as U1
import "UIConstants.js" as Const

Page {
    id: root
    title: qsTr("Login")
    orientation: "auto"

    function getToken() {
        mask.state = "busy";
        U1.getToken(user.text,pass.text,root)
    }

    function onResp(secrets,account) {
        mask.state = "idle";
        Utils.setCustomerKey(secrets.consumer_key);
        Utils.setCustomerSecret(secrets.consumer_secret);
        Utils.setToken(secrets.token);
        Utils.setTokenSecret(secrets.secret);
        Utils.setName(account.username);

        tip.show(qsTr("Logged in!"));
        pageStack.initialPage = "StartPage.qml";
    }

    function onErr(status) {
        mask.state = "idle";
        //console.log("onErr");
        if(status==401) {
            tip.show(qsTr("Authorization failed!"));
        } else if(status==0) {
            tip.show(qsTr("Unable to connect!"));
        } else {
            tip.show(qsTr("Error: ")+status);
        }
    }

    Flickable {
        width: root.width
        height: root.height
        contentHeight: content.height+Const.SYSTEM_BAR_HEIGHT+Const.TEXT_MARGIN
        y: Const.SYSTEM_BAR_HEIGHT+2*Const.TEXT_MARGIN

        Column {
            id: content
            spacing: Const.DEFAULT_MARGIN
            x: Const.TEXT_MARGIN

            Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("Ubuntu One sign in:")
            }

            Spacer {}

            TextField {
                id: user
                placeholderText: qsTr("User ID")
                width: 400
            }

            TextField {
                id: pass
                width: 400
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
            }

            Spacer {}

            Button {
                label: qsTr("Save")
                onButtonClicked: root.getToken()
            }
        }
    }
}
