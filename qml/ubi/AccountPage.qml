import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const
import "u1.js" as U1
import "bytesconv.js" as Conv

Page {
    id: root
    title: qsTr("Account")

    property variant secrets

    Component.onCompleted: init()

    function init()
    {
        secrets = {
            token: Utils.token(),
            secret: Utils.tokenSecret(),
            consumer_key : Utils.customerKey(),
            consumer_secret: Utils.customerSecret()
        };
        mask.state = "busy";
        U1.getAccount(secrets,root);
    }

    function onResp(secrets,account)
    {
        //console.log("onResp");
        mask.state = "idle";

        //uid.text = account.id;
        username.text = account.username;
        //nick.text = account.nickname;
        email.text = account.email;
        storage.text = Conv.bytesToSize(account.total_storage);
    }

    function onErr(status)
    {
        //console.log("onErr");
        mask.state = "idle";
        if(status==401) {
            tip.show(qsTr("Authorization failed!"));
        } else if(status==0) {
            tip.show(qsTr("Unable to connect!"));
        } else {
            tip.show(qsTr("Error: ")+status);
        }
        pageStack.pop();
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

            /*Text {
                font.pixelSize: 30
                color: "white"
                text: "Id:"
            }
            Text {
                id: uid
                font.pixelSize: 30
                color: "black"
                wrapMode: Text.Wrap
                width: root.width - 6*Const.DEFAULT_MARGIN
            }*/
            Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("User name:")
            }
            Text {
                id: username
                font.pixelSize: 30
                color: "black"
                wrapMode: Text.Wrap
                width: root.width - 6*Const.DEFAULT_MARGIN
            }
            Line {
                width: root.width-2*Const.TEXT_MARGIN
            }
            /*Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("Nickname:")
            }
            Text {
                id: nick
                font.pixelSize: 30
                color: "black"
                wrapMode: Text.Wrap
                width: root.width - 6*Const.DEFAULT_MARGIN
            }*/
            Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("Email:")
            }
            Text {
                id: email
                font.pixelSize: 30
                color: "black"
                wrapMode: Text.Wrap
                width: root.width - 6*Const.DEFAULT_MARGIN
            }
            Line {
                width: root.width-2*Const.TEXT_MARGIN
            }
            Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("Total storage:")
            }
            Text {
                id: storage
                font.pixelSize: 30
                color: "black"
                wrapMode: Text.Wrap
                width: root.width - 6*Const.DEFAULT_MARGIN
            }
            Spacer{}
        }
    }
}
