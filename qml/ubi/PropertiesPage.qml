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
    property bool isPublic

    property alias taskMenu: taskMenu

    menu: [
        [qsTr("Download"),false],
        [qsTr("Publish"),false],
        [qsTr("Rename"),false],
        [qsTr("Delete"),false]
    ]

    function menuFun(id) {
        if(id==qsTr("Download")) {
            fileSelector.state = "visible";
        }
        if(id==qsTr("Publish")) {
            if(isPublic) {
                dialogStopPublish.open();
            } else {
                dialogStartPublish.open();
            }
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
                tip.show(qsTr("Ubuntu One authorization has failed. Try once again or check login settings."));
            } else {
                tip.show(qsTr("Unknown error: ")+status);
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
            if(prop && prop.is_public) {
                url.text = prop.public_url;
            }

        } else {
            tip.show(qsTr("Internal error!"));
        }
        root.properties = prop;
        if(root.properties && root.properties.is_public) {
            root.isPublic = true;
        } else {
            root.isPublic = false;
        }
    }

    /*function setContentType(type)
    {
        ctype.text = type;
        ctype.font.italic = false;
    }*/

    function onErr(status)
    {
        mask.state = "idle";
        if(status==401) {
            tip.show(qsTr("Ubuntu One authorization has failed. Try once again or check login settings."));
        } else if(status==0) {
            tip.show(qsTr("Unable to connect. Check internet connection."));
        } else {
            tip.show(qsTr("Unknown error: ")+status);
        }
    }

    function onRespRename(prop)
    {
        mask.state = "idle";
        init(prop); pageStack.prevPage().init();
        tip.show(qsTr("File renamed!"));
    }

    function onErrRename(status)
    {
        onErr(status);
    }

    function onRespStopPublishing(prop)
    {
        mask.state = "idle";
        init(prop); pageStack.prevPage().init();
        tip.show(qsTr("Publishing stopped!"));
    }

    function onErrStopPublishing(status)
    {
        onErr(status);
    }

    function onRespStartPublishing(prop)
    {
        mask.state = "idle";
        init(prop); pageStack.prevPage().init();
        tip.show(qsTr("Publishing started!"));
    }

    function onErrStartPublishing(status)
    {
        onErr(status);
    }

    Flickable {
        width: root.width
        height: root.height
        contentHeight: content.height+Const.TOP_BAR_HEIGHT+Const.SYSTEM_BAR_HEIGHT+Const.TEXT_MARGIN
        y: Const.TOP_BAR_HEIGHT

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
            Line {
                width: root.width-2*Const.TEXT_MARGIN
                visible: root.isPublic
            }
            Text {
                font.pixelSize: 30
                color: "white"
                text: qsTr("Public URL:")
                visible: root.isPublic
            }
            Text {
                id: url
                font.pixelSize: 30
                color: "black"
                wrapMode: Text.Wrap
                width: root.width - 6*Const.DEFAULT_MARGIN
                visible: root.isPublic
            }
            Button {
                label: qsTr("Copy")
                fontSize: 25
                visible: root.isPublic
                onButtonClicked: {
                    Utils.setClipboardText(url.text);
                    tip.show(qsTr("Public URL copied to clipboard!"));
                }
            }
            Spacer{}
        }
    }

    FileDialog {
        id: fileSelector
        z: 200
        hidden: true
        folder: Utils.lastFolder()=="" ? Const.DEFAULT_FOLDER : Utils.lastFolder()
        folderOnly: true
        onFolderSelected: {
            fileSelector.close();
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

    DialogYesNo {
        id: dialogStopPublish
        z: 200
        text: qsTr("Stop publishing?")
        onOpened: mask.state = "dialog"
        onClosed: {
            mask.state = "idle";
            if(ok) {
                mask.state = "busy";
                var currentPath = root.properties.resource_path;
                U1.stopPublishing(root.secrets,currentPath,root);
            }
        }
        onCanceled: mask.state = "idle"
    }

    DialogYesNo {
        id: dialogStartPublish
        z: 200
        text: qsTr("Start publishing?")
        onOpened: mask.state = "dialog"
        onClosed: {
            mask.state = "idle";
            if(ok) {
                mask.state = "busy";
                var currentPath = root.properties.resource_path;
                U1.startPublishing(root.secrets,currentPath,root);
            }
        }
        onCanceled: mask.state = "idle"
    }


    function getParentPath(path) {
        var ppath;
        var ind = path.lastIndexOf("/");
        if(ind>=0) {
            ppath = path.substr(0,ind);
        }
        if(path=="") ppath = "/";
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
            mask.state = "dialog";
        }
        onClosed: {
            mask.state = "idle";
            var r = trim(resp);
            if(r!="") {
                mask.state = "busy";
                var currentPath = root.properties.resource_path;
                var targetPath = getParentPath(root.properties.path)+"/"+resp;
                U1.renameFile(secrets,currentPath,targetPath,root);;
            } else {
                tip.show(qsTr("Invalid file name!"))
            }
        }
        onCanceled: {
            mask.state = "idle";
        }
    }

    TaskMenu {
        z: 200
        id: taskMenu

        contexMenu: true
        menuDynamic: _menuDyn
        menuHeight: menuDynamic.height+menuFixed.height+7*Const.DEFAULT_MARGIN

        Flow {
            id: _menuDyn

            y: root.height-taskMenu.menuHeight-Const.SYSTEM_BAR_HEIGHT+2*Const.DEFAULT_MARGIN
            x: Const.DEFAULT_MARGIN

            width: parent.width-2*Const.DEFAULT_MARGIN
            spacing: Const.DEFAULT_MARGIN

            Button {
                label: qsTr("Download");
                onButtonClicked: {
                    taskMenu.close();
                    fileSelector.open();
                }
            }

            Button {
                label: qsTr("Publish");
                onButtonClicked: {
                    taskMenu.close();
                    if(isPublic) {
                        dialogStopPublish.open();
                    } else {
                        dialogStartPublish.open();
                    }
                }
            }

            Button {
                label: qsTr("Rename");
                onButtonClicked: {
                    taskMenu.close();
                    dialogRename.open();
                }
            }

            Button {
                label: qsTr("Delete");
                onButtonClicked: {
                    taskMenu.close();
                    dialogDelete.open();
                }
            }
        }
    }

}
