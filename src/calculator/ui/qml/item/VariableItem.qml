import QtQuick 2.0

import "../visualization" as Visualization
import "../menu" as Menu

Rectangle {
    id: component

    signal valueSetRequest(string identifier, int value)
    signal deleteRequest(string identifier)

    property alias textColor: content.textColor
    property alias identifierTextColor: content.identifierTextColor
    property alias variableIdentifier: content.variableIdentifier
    property alias variableExpression: content.variableExpression
    property alias variableValue: content.variableValue

    color: "#2A2A2A"
    clip: true

    Visualization.VariableDisplay {
        id: content

        width: parent.width - optionsMenu.menuWidth
        height: parent.height
    }


    Menu.VariableOptions {
        id: optionsMenu

        height: parent.height
        width: parent.width / 3.2

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
