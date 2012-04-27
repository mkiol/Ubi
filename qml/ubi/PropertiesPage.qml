import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const
import "ISOdate.js" as ISOdate
import "bytesconv.js" as Conv
import "u1.js" as U1

Page {
    id: root
    title: qsTr("File")

    property variant secrets
    property variant properties

    menu: [
        [qsTr("Download"),false],
        [qsTr("Rename"),false],
        [qsTr("Delete"),false]
    ]

    function menuFun(id) {
        if(id==qsTr("Download")) {
            fileSelector.state = "visible";
        }
        if(id==qsTr("Rename")) {
            dialogRename.open();
        }
        if(id==qsTr("Delete")) {
            dialogDelete.open();
        }
    }

    Connections {
        target: Utils
        onFileDeleted: {
            mask.state = "idle";
            tip.show(qsTr("File deleted!"));
            pageStack.pop();
            pageStack.currentPage.init();
        }
        onOperationError: {
            mask.state = "idle";
            if(status==401) {
                tip.show(qsTr("Authorization failed!"));
            } else {
                tip.show(qsTr("Error: ")+status);
            }
        }
    }

    function init(prop)
    {
        secrets = {
            token: Utils.token(),
            secret: Utils.tokenSecret(),
            consumer_key : Utils.customerKey(),
            consumer_secret: Utils.customerSecret()
        };

        if(prop) {
            var name = U1.fixFilename(prop.path);
            //console.log(name);
            filename.text = name;
            var crd = new Date(); crd.setISO8601(prop.when_created);
            var chd = new Date(); chd.setISO8601(prop.when_changed);
            created.text = Qt.formatDateTime(crd, "d/M/yyyy h:mm");
            changed.text = Qt.formatDateTime(chd, "d/M/yyyy h:mm");
            size.text = Conv.bytesToSize(prop.size);
        } else {
            tip.show(qsTr("Internal error!"));
        }
        root.properties = prop;
    }

    function setContentType(type)
    {
        //ctype.text = type;
        //ctype.font.italic = false;
    }

    function onRespRename(prop)
    {
        //console.log("onRespRename");
        mask.state = "idle";
        init(prop); pageStack.prevPage().init();
        tip.show(qsTr("File renamed!"));
    }

    function onErrRename(status)
    {
        //console.log("onErrRename");
        mask.state = "idle";
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
        y: Const.SYSTEM_BAR_HEIGHT+Const.TEXT_MARGIN

        Column {
            id: content
            spacing: Const.DEFAULT_MARGIN
            x: Const.TEXT_MARGIN

            Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("File name:")
            }
            Text {
                id: filename
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
                text: qsTr("Size:")
            }
            Text {
                id: size
                font.pixelSize: 30
                color: "black"
                wrapMode: Text.Wrap
            }
            Line {
                width: root.width-2*Const.TEXT_MARGIN
            }
            Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("Created:")
            }
            Text {
                id: created
                font.pixelSize: 30
                color: "black"
            }
            Line {
                width: root.width-2*Const.TEXT_MARGIN
            }
            Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("Changed:")
            }
            Text {
                id: changed
                font.pixelSize: 30
                color: "black"
            }
            /*Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("Preview:")
            }
            Rectangle {
                color: Const.TRANSPARENT
                height: 200; width: 200
                border.color: Const.DEFAULT_FOREGROUND_COLOR
                border.width: 1
                radius: 5
            }*/

            Spacer{}

        }
    }

    FileSelector {
        id: fileSelector
        z: 200
        y: 200
        folder: Utils.lastFolder()=="" ? Const.DEFAULT_FOLDER : Utils.lastFolder()
        onFolderSelected: {
            fileSelector.state = "invisible";
            U1.getFileContent(secrets,root,properties.content_path,folder,properties.size,Utils);
            Utils.setLastFolder(folder);
        }
    }

    DialogYesNo {
        id: dialogDelete
        z: 200
        text: qsTr("Delete file?")
        onOpened: mask.state = "dialog"
        onClosed: {
            mask.state = "idle";
            if(ok) {
                mask.state = "busy";
                U1.deleteFile(secrets,properties.resource_path,root,Utils);
            }
        }
        onCanceled: mask.state = "idle"
    }


    function getParentPath(path) {
        //console.log(path);
        var ppath;
        var ind = path.lastIndexOf("/");
        if(ind>=0) {
            ppath = path.substr(0,ind);
        }
        if(path=="") ppath = "/";

        //console.log(ppath);
        return ppath;
    }

    function trim(s) {
        var l=0; var r=s.length -1;
        while(l < s.length && s[l] == ' ')
        {	l++; }
        while(r > l && s[r] == ' ')
        {	r-=1;	}
        return s.substring(l, r+1);
    }

    DialogInput {
        id: dialogRename
        z: 200
        textWidth: root.width - 4*Const.DEFAULT_MARGIN
        label: qsTr("Enter new file name:")
        placeholderText: filename.text
        onOpened: {
            reset();
            Utils.setOrientation("auto");
            mask.state = "dialog";
        }
        onClosed: {
            mask.state = "idle";
            Utils.setOrientation(root.orientation);
            var r = trim(resp);
            if(r!="") {
                mask.state = "busy";
                var currentPath = root.properties.resource_path;
                var targetPath = getParentPath(root.properties.path)+"/"+resp;
                //console.log("targetPath: "+targetPath);
                U1.renameFile(secrets,currentPath,targetPath,root);;
            } else {
                tip.show(qsTr("Invalid file name!"))
            }
        }
        onCanceled: {
            Utils.setOrientation(root.orientation);
            mask.state = "idle";
        }
    }

}
