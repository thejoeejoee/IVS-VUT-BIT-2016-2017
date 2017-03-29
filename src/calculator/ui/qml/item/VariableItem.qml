import QtQuick 2.0

import "../visualization" as Visualization
import "../menu" as Menu

/**
  Single item which represents variable
  */
Item {
    id: component

    /**
      Emits to request variable set value
      @param idendifier Identifier of variable
      @param value Reqested new value of variable
      */
    signal valueSetRequest(string identifier, int value)
    /**
      Emits to request variable deletion
      @param idendifier Identifier of variable
      */
    signal deleteRequest(string identifier)
    /**
      Emits request to expand text by variable data
      @param data String requested to be expanded
      */
    signal expandRequest(string data)
    /**
      Emits request to overwrite text by variable data
      @param data String requested to be expanded
      */
    signal overwriteRequest(string data)

    /// Background color
    property alias color: content.color
    /// Text color
    property alias textColor: content.textColor
    /// Text color of identifier
    property alias identifierTextColor: content.identifierTextColor
    /// Variable identifier
    property alias variableIdentifier: content.variableIdentifier
    /// Variable expression
    property alias variableExpression: content.variableExpression
    /// Background color of expression when hovered
    property alias expressionHoverColor: content.expressionHoverColor
    /// Variable value
    property alias variableValue: content.variableValue
    /// Used font
    property alias font: content.font

    /// Background color of dots(area to slide variable options)
    property alias dotsBackgroundColor: optionsMenu.dotsBackgroundColor
    /// Background color of variable remove button
    property alias removeButtonColor: optionsMenu.removeButtonColor
    /// Background color of variable setters
    property alias settersColor: optionsMenu.settersColor
    /// Background color of variable setters when hovering
    property alias settersHoveredColor: optionsMenu.settersHoveredColor
    /// Text color of variable setters
    property alias settersTextColor: optionsMenu.settersTextColor


    clip: true

    Visualization.VariableDisplay {
        id: content

        width: parent.width - optionsMenu.menuWidth
        height: parent.height

        onExpandRequest: component.expandRequest(data)
        onOverwriteRequest: component.overwriteRequest(data)
    }

    Menu.VariableOptions {
        id: optionsMenu

        height: parent.height
        width: parent.width / 3.2

        font: content.font

        anchors.top: parent.top
        anchors.left: parent.right
        anchors.leftMargin: -optionsMenu.menuWidth

        onValueSetRequest: component.valueSetRequest(component.variableIdentifier, value)
        onDeleteRequest: SequentialAnimation {
            NumberAnimation { target: component; property: "opacity"; from: 1; to: 0; duration: 200 }
            ScriptAction { script: component.deleteRequest(component.variableIdentifier) }
        }
    }
}
