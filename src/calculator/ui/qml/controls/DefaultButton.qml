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

/**
  Regular styled button
  */
Clickable {
    id: component

    /// Color of button
    property color color
    /// Color of background which is behind button
    property color backgroundColor
    /// Label of button
    property alias text: buttonText.text
    /// Font of button
    property font font

    hoverEnabled: true

    onEntered: ParallelAnimation {
        ColorAnimation { target: background; property: "border.color"; to: "transparent"; duration: 200 }
        ColorAnimation { target: background; property: "color"; to: component.color; duration: 200 }
        ColorAnimation { target: buttonText; property: "color"; to: component.backgroundColor; duration: 200 }
    }

    onExited: ParallelAnimation {
        ColorAnimation { target: background; property: "border.color"; to: component.color; duration: 200 }
        ColorAnimation { target: background; property: "color"; to: "transparent"; duration: 200 }
        ColorAnimation { target: buttonText; property: "color"; to: component.color; duration: 200 }
    }

    Rectangle {
        id: background

        color: "transparent"
        border.color: component.color
        border.width: 1.5
        anchors.fill: parent
    }

    Text {
        id: buttonText

        color: component.color

        font.pixelSize: parent.height * 0.7
        font.family: component.font.family

        anchors.centerIn: parent
    }
}
