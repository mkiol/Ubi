import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import Qt 4.7
import "u1.js" as U1
import "bytesconv.js" as Conv
import "UIConstants.js" as Const

Page {
    id: root
    title: qsTr("Files")

    property variant secrets
    property string resource_path: "/~/Ubuntu One";
    property string content_path: "/content/~/Ubuntu One";
    property variant properties
    property string path
    property string name

    property alias taskMenu: taskMenu

    function init(prop)
    {
        if(mask.state!="defocused" && mask.state!="dialog") {
            mask.state = "busy";
        }
        if(root.properties && !prop) {
            prop = root.properties;
        }

        secrets = {
            token: Utils.token(),
            secret: Utils.tokenSecret(),
            consumer_key : Utils.customerKey(),
            consumer_secret: Utils.customerSecret()
        };
        if(prop) {
            root.path = prop.path;
            root.name = U1.fixFilename(prop.path);
            U1.getFiles(secrets,prop.resource_path,root);
            resource_path = prop.resource_path;
            content_path = prop.content_path;
        } else {
            root.path = "/";
            root.name = "";
            U1.getFileTree(secrets,root);
        }
        root.properties = prop;
    }

    function onResp(nodes)
    {
        createFilesView(nodes);
    }

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
        pageStack.pop();
        initPage.hide()
    }


    function onRespRename()
    {
        pageStack.prevPage().init();
        mask.state = "idle";
        tip.show(qsTr("Folder renamed!"));
    }

    function onErrRename(status)
    {
        mask.state = "idle";
        if(status==401) {
            tip.show(qsTr("Ubuntu One authorization has failed. Try once again or check login settings."));
        } else {
            tip.show(qsTr("Unknown error: ")+status);
        }
    }

    function onRespNew()
    {
        pageStack.currentPage.init();
        mask.state = "idle";
        tip.show(qsTr("New folder created!"));
    }

    function onErrNew(status)
    {
        onErrRename(status);
    }

    function createFilesView(nodes)
    {
        var i,l;
        if(files.children.length>0) {
            l = files.children.length;
            for(i=0;i<l;++i) {
                files.children[i].destroy();
            }
        }
        var component = Qt.createComponent("components/File.qml");
        l = nodes.length;
        for (i=0; i<l; i++) {
            var object = component.createObject(files);
            var ind = nodes[i].path.lastIndexOf("/");
            if(ind>=0) {
                object.name = nodes[i].path.substr(ind+1);
            }  else {
                object.name = nodes[i].path;
            }
            object.isDirectory = nodes[i].kind == "directory";
            object.properties = nodes[i];
            if(object.isDirectory) {
                object.clicked.connect(function(prop) {
                            pageStack.push("FilesPage.qml");
                            pageStack.currentPage.init(prop);
                        });
            } else {
                var txt = "" + Conv.bytesToSize(nodes[i].size);
                object.description = txt;
                object.isPublic = nodes[i].is_public;
                object.clicked.connect(function(prop) {
                            pageStack.push("PropertiesPage.qml");
                            pageStack.currentPage.init(prop);
                        });

                // extension
                ind = object.name.lastIndexOf(".");
                var ext = "";
                if(ind>=0) ext = object.name.substr(ind+1);
                if(ext=="jpg" || ext=="JPG" || ext=="Jpg" ||
                   ext=="jpeg" || ext=="JPEG" || ext=="Jpeg" ||
                   ext=="gif" || ext=="GIF" || ext=="Gif" ||
                   ext=="svg" || ext=="SVG" || ext=="Svg" ||
                   ext=="png" || ext=="PNG" || ext=="Png") {
                    object.isPhoto = true;
                }
                if(ext=="mp3" || ext=="MP3" || ext=="Mp3" ||
                   ext=="wma" || ext=="WMA" || ext=="Wma" ||
                   ext=="wav" || ext=="WAV" || ext=="Wav" ||
                   ext=="ogg" || ext=="OGG" || ext=="Ogg" ||
                   ext=="acc" || ext=="ACC" || ext=="Acc" ||
                   ext=="m4a" || ext=="M4A" || ext=="M4a" ||
                   ext=="flac" || ext=="FLAC" || ext=="Flac") {
                    object.isMusic = true;
                }
                if(ext=="avi" || ext=="AVI" || ext=="Avi" ||
                   ext=="mp4" || ext=="MP4" || ext=="Mp4" ||
                   ext=="mpg" || ext=="MPG" || ext=="Mpg" ||
                   ext=="mkv" || ext=="MKV" || ext=="Mkv" ||
                   ext=="flv" || ext=="FLV" || ext=="Flv" ||
                   ext=="m4v" || ext=="M4V" || ext=="M4v" ||
                   ext=="3gp" || ext=="3GP") {
                    object.isVideo = true;
                }
            }
        }
        if(mask.state!="defocused" && mask.state!="dialog") {
            mask.state = "idle";
        }

        if(l==0) {
            empty.visible = true;
        } else {
            empty.visible = false;
        }

        initPage.hide()
    }

    Connections {
        target: Utils
        onFileUploaded: init(root.properties);
    }

    Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        contentHeight: files.height+Const.TOP_BAR_HEIGHT+Const.SYSTEM_BAR_HEIGHT+Const.TEXT_MARGIN
        y: Const.TOP_BAR_HEIGHT
        contentWidth: parent.width

        Column {
            id: files
            add: Transition {
                NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
            }
        }
    }

    Text {
        id: empty
        font.pixelSize: Const.DEFAULT_FONT_PIXEL_SIZE
        color: Const.DEFAULT_FOREGROUND_COLOR
        text: qsTr("Empty")
        anchors.centerIn: parent
        font.italic: true
        visible: false
    }

    FileDialog {
        id: fileSelector
        z: 200
        hidden: true
        folder: Utils.lastFolder()=="" ? Const.DEFAULT_FOLDER : Utils.lastFolder()
        folderOnly: false
        onFileSelected: {
            mask.state = "idle";
            fileSelector.close();
            Utils.setLastFolder(folder);
            var path = content_path+"/"+file;
            U1.uploadFile(secrets,root,path,file,folder,Utils);
        }
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

    Connections {
        target: Utils
        onFileDeleted: {
            if(pageStack.currentPage==root) {
                mask.state = "idle";
                tip.show(qsTr("Folder was deleted!"));
                pageStack.pop();
                pageStack.currentPage.init();
            }
        }
        onOperationError: {
            if(pageStack.currentPage==root) {
                mask.state = "idle";
                if(status==401) {
                    tip.show(qsTr("Authorization failed!"));
                } else {
                    tip.show(qsTr("Error: ")+status);
                }
            }
        }
    }

    DialogYesNo {
        id: dialogDelete
        z: 200
        text: qsTr("Delete folder?")
        onOpened: mask.state = "dialog"
        onClosed: {
            if(ok) {
                mask.state = "busy";
                U1.deleteFile(secrets,properties.resource_path,root,Utils);
            }
        }
    }

    DialogInput {
        id: dialogRename
        z: 200
        textWidth: root.width - 4*Const.DEFAULT_MARGIN
        label: qsTr("Enter new folder name:")
        placeholderText: root.name
        onOpened: {
            reset();
            Utils.setOrientation("auto");
        }
        onClosed: {
            mask.state = "idle";
            Utils.setOrientation(root.orientation);
            var r = trim(resp);
            if(r!="") {
                mask.state = "busy";
                var currentPath = root.properties.resource_path;
                var targetPath = getParentPath(root.properties.path)+"/"+resp;
                U1.renameFile(secrets,currentPath,targetPath,root);
            } else {
                tip.show(qsTr("Invalid folder name!"))
            }
        }
        onCanceled: {
            Utils.setOrientation(root.orientation);
        }
    }

    DialogInput {
        id: dialogNew
        z: 200
        textWidth: root.width - 4*Const.DEFAULT_MARGIN
        label: qsTr("Enter new folder name:")
        placeholderText: ""
        onOpened: {
            reset();
            Utils.setOrientation("auto");
        }
        onClosed: {
            Utils.setOrientation(root.orientation);
            var r = trim(resp);
            if(r!="") {
                mask.state = "busy";
                var rpath;
                if(root.properties)
                    rpath = root.properties.resource_path;
                else
                    rpath = root.resource_path;
                var newPath = rpath+"/"+resp;
                U1.newFolder(secrets,newPath,root);
            } else {
                tip.show(qsTr("Invalid folder name!"))
            }
        }
        onCanceled: {
            Utils.setOrientation(root.orientation);
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
                label: qsTr("Upload file");
                onButtonClicked: {
                    taskMenu.close();
                    fileSelector.open();
                }
            }

            Button {
                label: qsTr("Rename");
                onButtonClicked: {
                    taskMenu.close();
                    if(root.path=="/") {
                        tip.show(qsTr("Root folder cannot be renamed."));
                    } else {
                        dialogRename.open();
                    }
                }
            }

            Button {
                label: qsTr("Delete");
                onButtonClicked: {
                    taskMenu.close();
                    if(root.path=="/") {
                        tip.show(qsTr("Root folder cannot be deleted."));
                    } else {
                        dialogDelete.open();
                    }
                }
            }

            Button {
                label: qsTr("New folder");
                onButtonClicked: {
                    taskMenu.close();
                    dialogNew.open();
                }
            }

            Button {
                label: qsTr("Refresh");
                onButtonClicked: {
                    taskMenu.close();
                    init(root.properties);
                }
            }
        }
    }
}
