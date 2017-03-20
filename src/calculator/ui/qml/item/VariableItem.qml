import QtQuick 2.0

import "../visualization" as Visualization
import "../menu" as Menu

Item {
    id: component

    signal valueSetRequest(string identifier, int value)
    signal deleteRequest(string identifier)
    signal expandRequest(string data)
    signal overwriteRequest(string data)

    property alias color: content.color
    property alias textColor: content.textColor
    property alias identifierTextColor: content.identifierTextColor
    property alias variableIdentifier: content.variableIdentifier
    property alias variableExpression: content.variableExpression
    property alias expressionHoverColor: content.expressionHoverColor
    property alias variableValue: content.variableValue
    property alias font: content.font

    property alias dotsBackgroundColor: optionsMenu.dotsBackgroundColor
    property alias removeButtonColor: optionsMenu.removeButtonColor
    property alias settersColor: optionsMenu.settersColor
    property alias settersHoveredColor: optionsMenu.settersHoveredColor
    property alias settersTextColor: optionsMenu.settersTextColor


    clip: true

    Visualization.VariableDisplay {
        id: content

        width: parent.width - optionsMenu.menuWidth
        height: parent.height

        onExpandRequest: component.expandRequest(data)
        onOverwriteRequest: component.overwriteRequest(data)
    }

// TODO styles
    Menu.VariableOptions {
        id: optionsMenu

        height: parent.height
        width: parent.width / 3.2

        font: content.font

        anchors.top: parent.top
        anchors.left: parent.right
        anchors.leftMargin: -optionsMenu.menuWidth
    }

    Connections {
        target: optionsMenu

        onValueSetRequest: component.valueSetRequest(component.variableIdentifier, value)
        onDeleteRequest: component.deleteRequest(component.variableIdentifier)
    }
}
