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
import "../controls" as Controls

Controls.FilledClickable {
    id: component

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

    /// Text color
    property color textColor
    /// Text color of identifier
    property color identifierTextColor
    /// Background color of expression when hovered
    property alias expressionHoverColor: expressionBackground.color
    /// Variable identifier
    property string variableIdentifier: ""
    /// Variable expression
    property string variableExpression: ""
    /// Variable value
    property string variableValue: "0"
    /// Used font
    property font font
    /// Color of value scrollbar
    property color scrollbarColor
    /// Prompter of value flickable theme
    property string prompterTheme

    hoverEnabled: true
    hoverMaskEnabled: true
    manual: true

    mouseArea.onClicked: {
        if(mouse.button == Qt.LeftButton)
            component.expandRequest(component.variableIdentifier)
        else
            component.expandRequest(component.variableValue)
    }

    mouseArea.onContainsMouseChanged: component.handleHoverEvent()

    QtObject {
        id: internal

        property real sideMargin: height / 6.5
    }

    Rectangle {
        id: expressionBackground

        opacity: 0

        width: component.width
        height: expression.y + expression.height + leftSide.y
        anchors.top: parent.top

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    // value display
    AnimatedText {
        text: component.variableValue
        color: component.textColor

        font.family: component.font.family
        font.pixelSize: parent.height * 0.55

        anchors.right: parent.right
        anchors.rightMargin: internal.sideMargin
        anchors.bottom: leftSide.bottom
    }

    // display expression and variable name
    Item {
        id: leftSide

        height: parent.height * 0.92

        anchors.leftMargin: internal.sideMargin
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        Text {
            antialiasing: true
            text: component.variableIdentifier
            color: component.identifierTextColor

            font.family: component.font.family
            font.pixelSize: parent.height * 0.58

            anchors.bottom: parent.bottom
            anchors.left: parent.left
        }

        Rectangle {
            color: component.scrollbarColor
            opacity: (expression.flick.visibleArea.widthRatio != 1 && expression.flick.moving)

            x: expression.width * expression.flick.visibleArea.xPosition + expression.x
            width: expression.width * expression.flick.visibleArea.widthRatio
            height: 2
            z: 2

            anchors.top: expression.bottom

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        FlickableAnimatedText {
            id: expression

            antialiasing: true
            text: component.variableExpression
            color: component.textColor
            theme: component.prompterTheme

            font.family: component.font.family
            font.pixelSize: parent.height * 0.23

            width: component.width - internal.sideMargin * 2
            height: flick.contentHeight


            anchors.left: parent.left
            anchors.top: parent.top

            MouseArea {
                id: expressionMouseArea

                parent: expression.flick
                hoverEnabled: true
                propagateComposedEvents: true

                anchors.fill: parent

                onClicked: createExpansionRequest()
                onContainsMouseChanged: {
                    component.handleHoverEvent()
                    if(containsMouse)
                        expressionBackground.opacity = 1
                    else
                        expressionBackground.opacity = 0
                }
            }
        }
    }

    function handleHoverEvent() {
        if(component.mouseArea.containsMouse || expressionMouseArea.containsMouse)
            component.entered()
        else if((!expressionMouseArea.containsMouse) && (!component.mouseArea.containsMouse)){
            component.exited()
        }
    }

    function createExpansionRequest() {
        if(component.variableExpression.indexOf("=") != -1)
            component.overwriteRequest(component.variableIdentifier + ' ' + component.variableExpression)
        else
            component.expandRequest(component.variableExpression)
    }
}
