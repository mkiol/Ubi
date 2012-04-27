import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "../UIConstants.js" as Const

Item {
    id: root
    property string title: ""
    property string orientation: Const.DEFAULT_ORIENTATION
    property variant menu
    property alias mask: _mask

    anchors.fill: parent

    Rectangle {
        anchors.right: parent.right
        anchors.left: parent.left
        height: parent.height
        y: Const.SYSTEM_BAR_HEIGHT
        color: Const.DEFAULT_BACKGROUND_COLOR
    }

    Mask {
        id: _mask
        z: 100
        anchors.fill: parent
        onClicked: taskBar.close()
    }

    Component.onCompleted: {
        Utils.setOrientation(orientation);
        reloadMenu();
    }

    function reloadMenu() {
        var buttons = root.menu;

        var menu = taskBar.getMenu();
        var comp = Qt.createComponent("Button.qml");

        var i,l;
        if(menu.children.length>0) {
            l = menu.children.length;
            for(i=0;i<l;++i) {
                menu.children[i].destroy();
            }
        }
        if(buttons && buttons.length>0) {
            l = buttons.length;
            for(i=0;i<l;++i) {
                var obj = comp.createObject(menu);
                if (obj==null) {
                    console.log("Error creating menu Button!");
                } else {
                    var b = buttons[i];
                    obj.label = b[0];
                    obj.disabled = b[1];
                    obj.buttonClicked.connect(function(name){
                        taskBar.close();
                        menuFun(name);
                    });
                }
            }
        }
    }
}
