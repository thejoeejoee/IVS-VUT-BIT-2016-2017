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

/**
  Specialized button to set value to variable
  */
Controls.Clickable {
    id: component

    /// Value which will be set to variable
    property int value: 0
    /// Background color
    property color color
    /// Background color when hovered
    property color hoverColor
    /// Text color
    property color textColor
    /// Font of text
    property font font

    hoverEnabled: true

    onEntered: background.color = component.hoverColor
    onExited: background.color = component.color

    Rectangle {
        id: background

        anchors.fill: parent
        color: component.color

        Behavior on color {
            ColorAnimation { duration: 400 }
        }
    }

    Text {
        text: "=" + component.value
        color: component.textColor

        font.family: component.font.family
        font.pixelSize: parent.height * 0.9

        anchors.centerIn: parent
    }
}
