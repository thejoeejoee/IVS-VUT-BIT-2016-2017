import QtQuick 2.0
import "../managers"
import "../visualization"

Item {
    id: component

    signal setVariableRequest(string identifier, real value)
    signal deleteVariableRequest(string identifier)
    signal expandRequest(string data)
    signal overwriteRequest(string data)

    property real itemHeight: 0
    property color textColor
    property color identifierTextColor
    property color color: backgroundColor
    property alias backgroundColor: background.color
    property alias scrollBarColor: scrollBar.color
    property color expressionHoverColor

    property alias ansColor: ansItem.color
    property alias ansTextColor: ansItem.textColor
    property alias ansIdentifierTextColor: ansItem.identifierTextColor
    property alias ansExpressionHoverColor: ansItem.expressionHoverColor

    property color dotsBackgroundColor
    property color removeButtonColor
    property color settersColor
    property color settersHoveredColor
    property color settersTextColor

    property font font

    clip: true

    VariablesManager {
        id: manager

        componentsParent: container

        Component.onCompleted: _initComponent()

        onSetItem: component.setVariableRequest(identifier, value)
        onDeleteItem: component.deleteVariableRequest(identifier)

        onNewItem: {
            object.color = Qt.binding(function() { return component.color })
            object.textColor = Qt.binding(function() { return component.textColor })
            object.expressionHoverColor = Qt.binding(function() { return component.expressionHoverColor })
            object.identifierTextColor = Qt.binding(function() { return component.identifierTextColor })
            object.font.family = Qt.binding(function() { return component.font.family })

            object.dotsBackgroundColor = Qt.binding(function() { return component.dotsBackgroundColor })
            object.removeButtonColor = Qt.binding(function() { return component.removeButtonColor })
            object.settersColor = Qt.binding(function() { return component.settersColor })
            object.settersHoveredColor = Qt.binding(function() { return component.settersHoveredColor })
            object.settersTextColor = Qt.binding(function() { return component.settersTextColor })

            object.width = Qt.binding(function() { return component.width })
            object.height = Qt.binding(function() { return component.itemHeight })

            object.overwriteRequest.connect(component.overwriteRequest)
            object.expandRequest.connect(component.expandRequest)
        }
    }

    Rectangle {
        id: background
        anchors.fill: flick
    }

    VariableDisplay {
        id: ansItem

        variableIdentifier: "Ans"
        variableExpression: variableValue
        variableValue: 0

        height: component.itemHeight

        font.family: component.font.family

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left

        Component.onCompleted: manager.registerVariable(ansItem)
        onExpandRequest: component.expandRequest(data)
        onOverwriteRequest: component.overwriteRequest(data)
    }

    Flickable{
        id: flick

        boundsBehavior: Flickable.StopAtBounds

        contentWidth: container.width
        contentHeight: container.height

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: ansItem.bottom
        anchors.bottom: parent.bottom

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

    function handleVariableAction(identifier, expression, value) {
        if(manager.findVariable(identifier) === null)
            manager.addVariable(identifier, expression, value)
        else
            manager.setVariable(identifier, expression, value)
    }

    function createVariable(identifier, expression, value) {
        manager.addVariable(identifier, expression, value)
    }


    function modifyVariable(identifier, expression, value) {
        manager.setVariable(identifier, expression, value)
    }
}
