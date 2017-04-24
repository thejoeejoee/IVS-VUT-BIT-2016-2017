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
  Base component for all buttons with background
  */
Clickable {
    id: component

    /// Background color
    property alias color: background.color
    /// Background color of mask when button is hovered
    property alias hoverColor: mask.color
    /// If true mask is applied when hovered
    property alias hoverMaskEnabled: mask.visible

    Rectangle {
        id: background
        anchors.fill: parent
    }

    Rectangle {
        id: mask

        opacity: 0
        visible: false

        anchors.fill: parent
    }

    hoverEnabled: true
    onPressed: mask.opacity = 0.2
    onReleased: {
        if(component.hovered)
            mask.opacity = 0.1
    }

    onEntered: mask.opacity = 0.1
    onExited: mask.opacity = 0
}
