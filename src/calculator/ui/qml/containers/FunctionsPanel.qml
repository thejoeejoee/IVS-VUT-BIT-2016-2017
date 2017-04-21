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
import "../controls" as Control

/**
  Panel of function buttons
  */
Item {
    id: component

    /// Emits after clicking on function button, so function identifier could be expanded
    signal expandRequest(string func)

    /// List of functions to be delegated
    property var items
    /// Number of columns in which will be button displayed
    property alias columns: grid.columns
    /// Background color of buttons
    property color backgroundColor
    /// Text color of labels on buttons
    property color textColor
    /// Background color of mask when button is hovered
    property color hoverColor

    Grid {
        id: grid

        rows: Math.ceil(component.items.length / columns)

        Repeater{
            model: component.items
            delegate: Control.TextButton{
                buttonText: modelData
                textColor: component.textColor
                color: component.backgroundColor
                hoverColor: component.hoverColor

                width: component.width / grid.columns
                height: component.height / grid.rows

                onClicked: component.expandRequest(modelData)
            }
        }
    }
}
