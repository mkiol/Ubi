import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const
import Qt 4.7
import Qt.labs.folderlistmodel 1.0


Item {
    id: root

    property string currentFilePath: fileSelector.currentFilePath
    property bool load: fileSelector.load
    property alias folder: folderModel.folder
    property bool folderOnly: true

    state: "invisible"

    signal folderSelected(string folder)
    signal fileSelected(string folder, string file)

    height: parent.height
    width: parent.width

    function fixPath(path) {
        path = path.toString();
        //console.log(path);
        var ind = path.lastIndexOf("/");
        if(ind>=0) {
            path = path.substr(ind+1);
        }
        if(path=="") path = "/";

        return path;
    }

    function open() {
        state = "visible";
    }

    function close() {
        state = "invisible";
    }

    Rectangle {
        id: fileSelector

        width: parent.width
        height: parent.height
        radius: 10

        property string currentFilePath: folderModel.folder
        property bool load: true
        property string folder: folderModel.folder

        state: "invisible"
        color: Const.DEFAULT_DIALOG_BACKGROUND_COLOR

        function setFolder(folder)
        {
            console.log(root.folder);
            console.log(folder);

            folderAnimation.folderToChange = folder;
            folderAnimation.start();
        }

        function loadFile(filePath) {
            engine.clearModels();
            storageThread.loadByUrl(filePath);
            fileSelector.currentFilePath = filePath;
            gestureListView.currentSetFilename =
                    helper.extractFilenameFromPath(filePath);

            if (!viewSwitcher.running) {
                viewSwitcher.switchView(gestureListView, true);
            }
        }

        function saveFile(filePath) {
            helper.saveGestures(filePath, engine);
            gestureListView.currentSetFilename =
                    helper.extractFilenameFromPath(filePath);

            if (!viewSwitcher.running) {
                viewSwitcher.switchView(gestureListView, true);
            }
        }

        Rectangle {
            id: pathController
            width: parent.width
            height: 80
            anchors.top: parent.top
            z: 1
            color: Const.LIGHT_AUBERGINE_COLOR

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2 * Const.DEFAULT_MARGIN
                height: parent.height - Const.DEFAULT_MARGIN

                Spacer {}

                Row {
                    width: parent.width
                    spacing: Const.DEFAULT_MARGIN

                    Button {
                        id: currentFolderButton
                        maxSize: 13
                        label: fixPath(folderModel.folder)
                        width: pathController.width-folderUpButton.width-cancelButton.width-4*Const.DEFAULT_MARGIN
                        onButtonClicked: root.folderSelected(folderModel.folder)
                        disabled: !root.folderOnly
                    }
                    Button {
                        id: folderUpButton
                        label: "up"
                        iconSource: "images/up.png"
                        onButtonClicked: fileSelector.setFolder(folderModel.parentFolder);
                    }
                    Button {
                        id: cancelButton
                        label: "cancel"
                        iconSource: "images/close.png"
                        onButtonClicked: {
                            root.close();
                            mask.state = "idle";
                        }
                    }
                }
            }

        } // pathController

        Shadow {
            y: pathController.height
            z: 1
        }

        Rectangle {
            id: folderModelContainer
            width: parent.width
            anchors.top: pathController.bottom;
            anchors.bottom: parent.bottom
            color: Const.TRANSPARENT
            radius: 30

            FolderListModel {
                id: folderModel
                //folder: "/"
                //nameFilters: [ "*.*" ]
            }

            Component {
                id: folderModelDelegate

                Rectangle {
                    width: parent.width;
                    height: folderModel.isFolder(index)? file.height + Const.DEFAULT_MARGIN : root.folderOnly? 0 : file.height + Const.DEFAULT_MARGIN
                    color: Const.TRANSPARENT
                    visible: root.folderOnly? folderModel.isFolder(index) : true

                    FileOld {
                        id: file
                        anchors.verticalCenter: parent.verticalCenter
                        name: fileName
                        filename: fileName
                        isDirectory: folderModel.isFolder(index)
                        textMax: root.width/17
                        onClicked: {
                            if(isDirectory)
                                fileSelector.setFolder(filePath);
                            else
                                root.fileSelected(folderModel.folder,filename)
                        }
                    }
                }
            } // Component

            ListView {
                id: folderModelView

                anchors {
                    fill: parent;
                    margins: Const.TEXT_MARGIN
                }

                model: folderModel
                delegate: folderModelDelegate

                SequentialAnimation {
                    id: folderAnimation

                    property string folderToChange

                    PropertyAnimation { target: folderModelView; property: "opacity"; to: 0; duration: 100 }
                    PropertyAction { target: folderModel; property: "folder"; value: folderAnimation.folderToChange }
                    PropertyAnimation { target: folderModelView; property: "opacity"; to: 1.0; duration: 100 }
                }
            }

        } // folderModelContainer
    }

    states: [
        State {
            name: "visible"
            PropertyChanges { target: root; opacity: 1 }
            PropertyChanges { target: root; y: Const.SYSTEM_BAR_HEIGHT }
        },
        State {
            name: "invisible"
            PropertyChanges { target: root; opacity: 0 }
            PropertyChanges { target: root; y: root.parent.height }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
        NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad }
    }
}

