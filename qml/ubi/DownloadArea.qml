import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const

Item {
    id: root

    property int count: 0

    height: taskView.height

    function addTask(type,filename)
    {
        //emptyLabel.visible = Utils.emptyQuee();
        //emptyLabel.visible = false;
        var comp = Qt.createComponent("components/Bar.qml");
        var obj = comp.createObject(taskView);
        if (obj==null) {
            console.log("Error creating object");
        } else {
            root.count++;
            obj.width = root.width
            obj.label = filename;
            if(type=="download")
                obj.isDownload = true;
            if(type=="upload")
                obj.isUpload = true;
        }
    }

    function setProgress(filename, progress)
    {
        var l = taskView.children.length;
        for(var i=0;i<l;++i) {
            var item = taskView.children[i];
            if(item && item.label==filename)
                item.setProgres(progress);
        }
    }

    function start(filename)
    {
        var l = taskView.children.length;
        for(var i=0;i<l;++i) {
            var item = taskView.children[i];
            if(item && item.label==filename)
                item.start();
        }
    }

    function stop(filename)
    {
        console.log("stop task");
        var l = taskView.children.length;
        for(var i=0;i<l;++i) {
            var item = taskView.children[i];
            if(item && item.label==filename) {
                //console.log("stop task 2");
                item.destroy();
                root.count--;
            }
        }
        //emptyLabel.visible = Utils.emptyQuee();
    }

    Column {
        id: taskView
        width: parent.width
        spacing: Const.DEFAULT_MARGIN

        Text {
            font.pixelSize: Const.DEFAULT_FONT_PIXEL_SIZE
            color: Const.DEFAULT_FOREGROUND_COLOR
            text: qsTr("No active downloads")
            visible: taskBar.isEmpty
        }

    }
}
