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
import "../managers"
import "../visualization"

/**
  Interactive panel which display all variables with their attributes
  */
Item {
    id: component

    /**
      Emit after clicking on set button of variable
      @param identifier Identifier of variable
      @param value Value requested to be set to value
      */
    signal setVariableRequest(string identifier, real value)
    /**
      Emits after clicking on delete button of variable
      @param identifier Identifier of variable
      */
    signal deleteVariableRequest(string identifier)
    /**
      Emits after clicking on certain part, it requests to some string to be expanded into user input
      @param data String which is requested to expansion
      */
    signal expandRequest(string data)
    /**
      Emits after clicking on certain part, it requests to some string to overwrite user input
      @param data String which is requested to overwrite
      */
    signal overwriteRequest(string data)

    /// Height if single variable item
    property real itemHeight: 0
    /// Text color of expression and value of variable
    property color textColor
    /// Text color of identifier and value of variable
    property color identifierTextColor
    /// Background color of single variable panel
    property color color: backgroundColor
    /// Background of panel
    property alias backgroundColor: background.color
    /// Color of scrollbar
    property alias scrollBarColor: scrollBar.color
    /// Background color of expression while hovering
    property color expressionHoverColor

    /// Background color of Ans variable
    property alias ansColor: ansItem.color
    /// Text color of identifier and value of Ans variable
    property alias ansTextColor: ansItem.textColor
    /// Text color of identifier and value of Ans variable
    property alias ansIdentifierTextColor: ansItem.identifierTextColor
    /// Background color of Ans variable expression while hovering
    property alias ansExpressionHoverColor: ansItem.expressionHoverColor
    /// Color of value scrollbar Ans variable
    property alias ansScrollbarColor: ansItem.scrollbarColor
    /// Prompter of value flickable theme in Ans
    property alias ansPrompterTheme: ansItem.prompterTheme
    /// Hover color of ans
    property alias ansHoverColor: ansItem.hoverColor

    /// Background color of dots(area to slide variable options)
    property color dotsBackgroundColor
    /// Background color of variable remove button
    property color removeButtonColor
    /// Background color of variable setters
    property color settersColor
    /// Background color of variable setters when hovering
    property color settersHoveredColor
    /// Text color of variable setters
    property color settersTextColor
    /// Color of value scrollbar
    property color itemScrollbarColor
    /// Prompter of value flickable theme of item
    property string prompterTheme
    /// Hover color of item
    property color hoverColor
    /// Font of panel
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
            object.scrollbarColor = Qt.binding(function() { return component.itemScrollbarColor })
            object.prompterTheme = Qt.binding(function() { return component.prompterTheme })
            object.hoverColor = Qt.binding(function() { return component.hoverColor })

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
        variableValue: "0"

        height: component.itemHeight
        z: 2

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

        y: flick.visibleArea.yPosition * flick.height + flick.y
        width: 3
        height: flick.height * flick.visibleArea.heightRatio

        Behavior on opacity {
            NumberAnimation { duration: 400 }
        }
    }

    /**
      Create once component to be able later instance that component
      */
    function _initComponent() {
        var itemComponent = Qt.createComponent("qrc:/qml/item/VariableItem.qml")
        manager.itemComponent = itemComponent

        if (itemComponent.status != Component.Ready)
            itemComponent.statusChanged.connect(function() {
                console.log(manager.itemComponent.errorString())
            });
    }

    /**
      Use create or modify variable according to if variable exists
      @param identifier Identifier of variable
      @param expression Expression of variable
      @param value Value of variable
      */
    function handleVariableAction(identifier, expression, value) {
        if(manager.findVariable(identifier) === null)
            manager.addVariable(identifier, expression, value)
        else
            manager.setVariable(identifier, expression, value)
    }

    /**
      Create new variable in panel
      @param identifier Identifier of variable
      @param expression Expression of variable
      @param value Value of variable
      */
    function createVariable(identifier, expression, value) {
        manager.addVariable(identifier, expression, value)
    }


    /**
      Modifies variable(set expression or value)
      @param identifier Identifier of variable
      @param expression New expression of variable
      @param value New value of variable
      */
    function modifyVariable(identifier, expression, value) {
        manager.setVariable(identifier, expression, value)
    }

    /**
      Delete variable item
      @param variableIdentifier Identifier of variable
      */
    function deleteVariable(variableIdentifier) {
        manager.deleteVariable(variableIdentifier)
    }
}
