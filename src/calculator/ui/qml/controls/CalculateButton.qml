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
  Button to confirm calculation
  */
FilledClickable {
    id: component

    hoverMaskEnabled: true
    hoverEnabled: true

    Image {
        source: "qrc:/assets/images/equal.svg"

        fillMode: Image.PreserveAspectFit
        width: parent.width / 2.2

        sourceSize: Qt.size(400, 400)

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.centerIn: parent
    }
}
