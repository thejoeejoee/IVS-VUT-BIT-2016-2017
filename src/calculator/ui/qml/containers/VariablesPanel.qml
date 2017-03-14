import QtQuick 2.0
import "../managers"

Item {
    id: component

    property real itemHeight: 0
    property color textColor
    property color identifierTextColor
    property alias backgroundColor: background.color
    property alias scrollBarColor: scrollBar.color
    property font font

    clip: true

    VariablesManager {
        id: manager

        componentsParent: container

        Component.onCompleted: {
            _initComponent()
        }

        onNewItem: {
            object.textColor = Qt.binding(function() { return component.textColor })
            object.identifierTextColor = Qt.binding(function() { return component.identifierTextColor })
            object.font.family = Qt.binding(function() { return component.font.family })

            object.width = Qt.binding(function() { return component.width })
            object.height = Qt.binding(function() { return component.itemHeight })
        }
    }

    Rectangle {
        id: background
        anchors.fill: flick
    }

    Flickable{
        id: flick

        boundsBehavior: Flickable.StopAtBounds

        contentWidth: container.width
        contentHeight: container.height

        anchors.fill: parent

        Stack {
            id: container
        }
    }

    // ----- SCROLLBAR -----
    Rectangle {
        id: scrollBar

        opacity: (flick.visibleArea.heightRatio === 1) ?0 :1

        y: flick.visibleArea.yPosition * component.height
        width: 3
        height: component.height * flick.visibleArea.heightRatio

        Behavior on opacity {
            NumberAnimation { duration: 400 }
        }
    }

    function _initComponent() {
        var itemComponent = Qt.createComponent("qrc:/qml/item/VariableItem.qml")
        manager.itemComponent = itemComponent

        if (itemComponent.status != Component.Ready)
            itemComponent.statusChanged.connect(function() {
                console.log(manager.itemComponent.errorString())
            });
    }


    function addVariable(identifier, expression, value) {
        manager.addVariable(identifier, expression, value)
    }
}
