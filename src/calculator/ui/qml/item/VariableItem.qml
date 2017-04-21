/**************************************************************************
**   Calculator
**   Copyright (C) 2017 /dej/uran/dom team
**   Authors: Son Hai Nguyen
**   Credits: Josef Kolář, Son Hai Nguyen, Martin Omacht, Robert Navrátil
**
**   This program is free software: you can redistribute it and/or modify
**   it under the terms of the GNU General Public License as published by
**   the Free Software Foundation, either version 3 of the License, or
**   (at your option) any later version.
**
**   This program is distributed in the hope that it will be useful,
**   but WITHOUT ANY WARRANTY; without even the implied warranty of
**   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**   GNU General Public License for more details.
**
**   You should have received a copy of the GNU General Public License
**   along with this program.  If not, see <http://www.gnu.org/licenses/>.
**************************************************************************/
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
    /**
      Used as function to delete item
      */
    signal deleteItem()

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
    /// Color of value scrollbar
    property alias scrollbarColor: content.scrollbarColor
    /// Prompter of value flickable theme
    property alias prompterTheme: content.prompterTheme

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
    /// Hover color of item
    property alias hoverColor: content.hoverColor

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
        onDeleteRequest: component.deleteRequest(component.variableIdentifier)
    }

    onDeleteItem: SequentialAnimation {
        NumberAnimation { target: component; property: "opacity"; from: 1; to: 0; duration: 200 }
        ScriptAction { script: component.destroy() }
    }
}
