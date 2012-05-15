import QtQuick 1.0

/* copyright (C) 2010-2012 Stuart Howarth */

Item {
    id: root

    property alias initialPage: initalPage.source
    property Item currentPage: pageView.currentItem.item
    property int index: pageView.currentIndex

    function prevPage() {
        return pageModel.children[pageView.currentIndex-1].item;
    }

    function push(item, immediate) {
        var loader = pageModel.children[pageView.currentIndex + 1];
        loader.source = item;
        if (immediate) {
            pageView.highlightMoveDuration = 0;
        }
        else {
            pageView.highlightMoveDuration = 200;
        }
        pageView.incrementCurrentIndex();
    }

    function pop(immediate) {
        var i = pageView.currentIndex;
        if (immediate) {
            pageView.highlightMoveDuration = 0;
        }
        else {
            pageView.highlightMoveDuration = 300;
        }
        pageView.decrementCurrentIndex();
        pageModel.children[i].source = "";
        currentPage.taskMenu.close();
        //taskBar.close();
        //root.currentPage.reloadMenu();
        //mask.state = "idle";
    }

    function clear(immediate) {
        if (immediate) {
            pageView.highlightMoveDuration = 0;
        }
        else {
            pageView.highlightMoveDuration = 300;
        }
        pageView.currentIndex = 0;
        for (var i = 1; i < pageModel.children.length; i++) {
            pageModel.children[i].source = "";
        }
    }

    function replace(item, immediate) {
        root.pop(true);
        root.push(item, immediate);
    }

    function dim() {
        root.state = "dim";
    }

    function undim() {
        root.state = "";
    }

    anchors.fill: parent

    VisualItemModel {
        id: pageModel

        Loader {
            id: initalPage

            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }

        Loader {
            width: mainWindow.width
            height: mainWindow.height
            opacity: index == pageView.currentIndex ? 1 : 0
        }
    }

    ListView {
        id: pageView
        anchors.fill: parent
        model: pageModel
        orientation: ListView.Horizontal
        interactive: false
        highlightMoveDuration: 100
    }

    states: State {
        name: "dim"
        PropertyChanges { target: root; opacity: 0.1 }
    }

    transitions: Transition {
        PropertyAnimation { target: root; properties: "opacity"; duration: 300 }
    }
}

