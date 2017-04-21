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
  Specialized component to show calculation result
  */
Rectangle {
    id: component

    /// Result to be displayed
    property alias result: text.text
    /// Text color
    property alias textColor: text.color
    /// Used font
    property font font

    AnimatedText {
        id: text

        font.family: component.font.family
        font.pixelSize: parent.height / 1.9

        anchors.right: parent.right
        anchors.rightMargin: font.pixelSize / 3.4
        anchors.bottom: parent.bottom
    }
}
