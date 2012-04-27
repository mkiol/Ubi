import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import Qt 4.7
import "u1.js" as U1
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

    menu: [
        [qsTr("Upload file"),false],
        [qsTr("Rename"),false],
        [qsTr("Delete"),false],
        [qsTr("New folder"),false],
        [qsTr("Refresh"),false]
    ]

    function menuFun(id) {
        if(id==qsTr("Upload file")) {
            mask.state = "dialog";
            fileSelector.open();
        }
        if(id==qsTr("Refresh")) {
            init(root.properties);
        }
        if(id==qsTr("Rename")) {
            if(root.path=="/") {
                tip.show(qsTr("Root folder can't be renamed!"));
            } else {
                dialogRename.open();
            }
        }
        if(id==qsTr("Delete")) {
            if(root.path=="/") {
                tip.show(qsTr("Root folder can't be deleted!"));
            } else {
                dialogDelete.open();
            }
        }
        if(id==qsTr("New folder")) {
            dialogNew.open();
        }
    }

    function init(prop)
    {
        if(mask.state!="defocused") {
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


    function onRespRename()
    {
        //console.log("onRespRename");
        pageStack.prevPage().init();
        mask.state = "idle";
        tip.show(qsTr("Folder renamed!"));
    }

    function onErrRename(status)
    {
        //console.log("onErrRenamed");
        mask.state = "idle";
        if(status==401) {
            tip.show(qsTr("Authorization failed!"));
        } else {
            tip.show(qsTr("Error: ")+status);
        }
    }

    function onRespNew()
    {
        //console.log("onRespNew");
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
        //console.log("l="+l);
        for (i=0; i<l; i++) {
            var object = component.createObject(files);
            var ind = nodes[i].path.lastIndexOf("/");
            object.textMax = root.width/17;
            //console.log("ind="+ind);
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
                object.clicked.connect(function(prop) {
                            pageStack.push("PropertiesPage.qml");
                            pageStack.currentPage.init(prop);
                        });
            }
        }
        if(mask.state!="defocused") {
            mask.state = "idle";
        }
    }

    Connections {
        target: Utils
        onFileUploaded: init(root.properties);
    }

    Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        contentHeight: files.height+Const.SYSTEM_BAR_HEIGHT+2*Const.TEXT_MARGIN
        y: Const.SYSTEM_BAR_HEIGHT+Const.TEXT_MARGIN
        contentWidth: parent.width

        Column {
            id: files
            spacing: Const.DEFAULT_MARGIN
            x: Const.TEXT_MARGIN
            add: Transition {
                NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
            }

            /*Text {
                font.pixelSize: Const.DEFAULT_FONT_PIXEL_SIZE
                color: Const.DEFAULT_FOREGROUND_COLOR
                text: "Empty"
                font.italic: true
                visible: files.children.length==1
            }*/
        }
    }

    FileSelector {
        id: fileSelector
        z: 200
        folder: Utils.lastFolder()=="" ? Const.DEFAULT_FOLDER : Utils.lastFolder()
        folderOnly: false
        onFileSelected: {
            mask.state = "idle";
            //console.log("selected: "+file+" "+U1.fixFolder(folder));
            fileSelector.close();
            Utils.setLastFolder(folder);
            var path = content_path+"/"+file;
            U1.uploadFile(secrets,root,path,file,folder,Utils);
        }

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
            mask.state = "idle";
            if(ok) {
                mask.state = "busy";
                U1.deleteFile(secrets,properties.resource_path,root,Utils);
            }
        }
        onCanceled: mask.state = "idle"
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
                U1.renameFile(secrets,currentPath,targetPath,root);
            } else {
                tip.show(qsTr("Invalid folder name!"))
            }
        }
        onCanceled: {
            Utils.setOrientation(root.orientation);
            mask.state = "idle";
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
            mask.state = "dialog";
        }
        onClosed: {
            mask.state = "idle";
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
                //console.log("newPath: "+newPath);
                U1.newFolder(secrets,newPath,root);
            } else {
                tip.show(qsTr("Invalid folder name!"))
            }
        }
        onCanceled: {
            Utils.setOrientation(root.orientation);
            mask.state = "idle";
        }
    }
}
