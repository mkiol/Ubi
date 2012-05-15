import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import "components"
import "UIConstants.js" as Const
import Qt 4.7
import Qt.labs.folderlistmodel 1.0

DialogBox {
    id: root

    property string currentFilePath: fileSelector.currentFilePath
    property bool load: fileSelector.load
    property alias folder: folderModel.folder
    property bool folderOnly: true

    signal folderSelected(string folder)
    signal fileSelected(string folder, string file)

    function fixPath(path) {
        path = path.toString();
        var ind = path.lastIndexOf("/");
        if(ind>=0) {
            path = path.substr(ind+1);
        }
        if(path=="") path = "/";

        return path;
    }

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: fileSelector

        anchors.left: root.left; anchors.right: root.right
        anchors.top: root.top

        height: parent.height

        property string currentFilePath: folderModel.folder
        property bool load: true
        property string folder: folderModel.folder

        color: Const.DEFAULT_DIALOG_BACKGROUND_COLOR

        function setFolder(folder) {
            folderAnimation.folderToChange = folder;
            folderAnimation.start();
        }

        Rectangle {
            id: pathController
            width: parent.width
            height: currentFolderButton.height+2*Const.DEFAULT_MARGIN
            anchors.top: parent.top
            z: 1
            color: Const.LIGHT_AUBERGINE_COLOR

            ButtonResizable {
                id: currentFolderButton
                anchors.margins: Const.DEFAULT_MARGIN
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: fixPath(folderModel.folder)
                width: pathController.width-folderUpButton.width-cancelButton.width-4*Const.DEFAULT_MARGIN
                height: folderUpButton.height
                onClicked: root.folderSelected(folderModel.folder)
                disabled: !root.folderOnly
            }
            Button {
                id: folderUpButton
                anchors.margins: Const.DEFAULT_MARGIN
                anchors.right: cancelButton.left
                anchors.verticalCenter: parent.verticalCenter
                label: "up"
                iconSource: "images/up.png"
                onButtonClicked: fileSelector.setFolder(folderModel.parentFolder);

            }
            Button {
                id: cancelButton
                anchors.margins: Const.DEFAULT_MARGIN
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                label: "cancel"
                iconSource: "images/close.png"
                onButtonClicked: {
                    root.close();
                    mask.state = "idle";
                }
            }

        }

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

            FolderListModel {
                id: folderModel
                //folder: "/"
                nameFilters: root.folderOnly ? [""] : ["*"]
            }

            Component {
                id: folderModelDelegate

                FileSmall {
                    id: file
                    width: root.width
                    visible: root.folderOnly? folderModel.isFolder(index) : true
                    text: fileName
                    isDirectory: folderModel.isFolder(index)
                    onClicked: {
                        if(isDirectory)
                            fileSelector.setFolder(filePath);
                        else
                            root.fileSelected(folderModel.folder,text)
                    }

                    Component.onCompleted: {
                        var ind = text.lastIndexOf(".");
                        var ext = "";
                        if(ind>=0) ext = text.substr(ind+1);
                        if(ext=="jpg" || ext=="JPG" || ext=="Jpg" ||
                           ext=="jpeg" || ext=="JPEG" || ext=="Jpeg" ||
                           ext=="gif" || ext=="GIF" || ext=="Gif" ||
                           ext=="svg" || ext=="SVG" || ext=="Svg" ||
                           ext=="png" || ext=="PNG" || ext=="Png") {
                            isPhoto = true;
                        }
                        if(ext=="mp3" || ext=="MP3" || ext=="Mp3" ||
                           ext=="wma" || ext=="WMA" || ext=="Wma" ||
                           ext=="wav" || ext=="WAV" || ext=="Wav" ||
                           ext=="ogg" || ext=="OGG" || ext=="Ogg" ||
                           ext=="acc" || ext=="ACC" || ext=="Acc" ||
                           ext=="flac" || ext=="FLAC" || ext=="Flac") {
                            isMusic = true;
                        }
                        if(ext=="avi" || ext=="AVI" || ext=="Avi" ||
                           ext=="mp4" || ext=="MP4" || ext=="Mp4" ||
                           ext=="mpg" || ext=="MPG" || ext=="Mpg" ||
                           ext=="mkv" || ext=="MKV" || ext=="Mkv" ||
                           ext=="flv" || ext=="FLV" || ext=="Flv" ||
                           ext=="3gp" || ext=="3GP") {
                            isVideo = true;
                        }
                    }
                }
            }

            ListView {
                id: folderModelView

                anchors {
                    fill: parent;
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

        }
    }
}

