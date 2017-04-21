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
import QtQuick.Controls 2.0
import StyleSettings 1.0

/**
  Component which offer suggestion to text inputs
  */
DropDown {
    id: component

    /// Background color of completer
    property color color
    /// List of suggestions
    property var constantModel
    /// Reference to targeted text input
    property var target
    /// Holds current word, so only matching words could be suggested
    property string currentText
    /// Background color of suggestion item when hovered
    property color hoverColor
    /// Text color of suggestions
    property color textColor

    scrollbarWidth: 3
    model: constantModel

    onModelChanged: {
        if(!model.length)
            component.hide()
    }

    onConstantModelChanged: updateModel()
    onCurrentTextChanged: updateModel()

    dropDownMenuBackground: Rectangle {
        color: component.color
        anchors.fill: parent
    }

    menuItem: Item {
        Rectangle {     // hover overlay
            opacity: 0.8
            color: (hovered) ?component.hoverColor :"transparent"

            anchors.fill: parent
        }

        Rectangle {
            id: symbol

            width: height
            height: component.itemHeight / 2
            color: StyleSettings.completer.typeColors[itemData["type"]]

            anchors.left: parent.left
            anchors.leftMargin: width
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            color: component.textColor
            text: itemData["identifier"]
            font.pixelSize: parent.height * 0.8
            anchors.left: symbol.right
            anchors.leftMargin: symbol.anchors.leftMargin
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    onTargetChanged: {
        component.target.Keys.pressed.connect(component.handleOtherKeys)
        component.target.Keys.upPressed.connect(component.moveUp)
        component.target.Keys.downPressed.connect(component.moveDown)
    }

    /**
      Update completer model according to constantModel
      */
    function updateModel()
    {
        var newModel = []

        for(var key in component.constantModel) {
            var value = component.constantModel[key]

            if(value["identifier"].search("^" + currentText) !== -1)
                newModel.push(value)
        }

        component.model = newModel
    }

    /**
      Manage completer actions based on key pressed. Cannot steal key event from text input, so connect it to target event
      @param event Passed key event
      */
    function handleOtherKeys(event) {
        if(event.key == Qt.Key_Space && (event.modifiers & Qt.ControlModifier)) {
            component.show()
            event.accepted = true
        }

        if(component.visible && component.model.length) {
            switch(event.key) {
                case Qt.Key_Return:
                case Qt.Key_Enter:
                    component.chooseCurrent()
                    break;
                case Qt.Key_Escape:
                    component.hide()
                    break;
            }
        }
    }
}
