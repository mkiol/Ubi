import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const

Item {
    id: root

    property int count: 0

    height: taskView.height+Const.DEFAULT_MARGIN

    function addTask(type,filename)
    {
        var comp = Qt.createComponent("components/Bar.qml");
        //var obj = comp.createObject(taskView,{"width": root.width});
        var obj = comp.createObject(taskView);
        if (obj==null) {
            console.log("Error creating object");
        } else {
            root.count++;
            //obj.width = root.width
            obj.label = filename;
            obj.cancel.connect(function(file) {
                                   Utils.cancelFile(file);
                                });
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
            if(item && item.label==filename) {
                item.setProgres(progress);
                return;
            }
        }
    }

    function start(filename)
    {
        var l = taskView.children.length;
        for(var i=0;i<l;++i) {
            var item = taskView.children[i];
            if(item && item.label==filename) {
                item.start();
                return;
            }
        }
    }

    function stop(filename)
    {
        var l = taskView.children.length;
        for(var i=0;i<l;++i) {
            var item = taskView.children[i];
            if(item && item.label==filename) {
                //console.log("stop task 2");
                item.destroy();
                root.count--;
                return;
            }
        }
    }

    Column {
        id: taskView
        width: parent.width
        spacing: Const.DEFAULT_MARGIN

        Text {
            font.pixelSize: Const.DEFAULT_FONT_PIXEL_SIZE
            color: Const.DEFAULT_FOREGROUND_COLOR
            width: parent.width
            wrapMode: Text.WordWrap
            text: root.count==0 ?
                      qsTr("No active downloads or uploads") :
                      qsTr("Active downloads and uploads")
            anchors.bottomMargin: 2*Const.DEFAULT_MARGIN
            visible: root.count==0
        }
    }
}
