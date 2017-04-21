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
  Component to display function signature
  */
Rectangle {
    id: component

    /**
      Used as function to display component
      @param signature Signature to display
      */
    signal show(string signature)
    /**
      Used as function to hide component
      */
    signal hide()

    /// Contains function signature in string
    property alias text: text.text
    /// Text color display
    property alias textColor: text.color
    property real constantOpacity
    /// Used font
    property font font

    opacity: constantOpacity
    width: text.width + height * 0.2

    onShow: {
        text.text = signature

        if(signature == "")
            component.hide()
        else
            component.opacity = component.constantOpacity
    }

    onHide: component.opacity = 0

    Behavior on opacity {
        NumberAnimation { duration: 250 }
    }

    Text {
        id: text

        font.family: component.font.family
        font.pixelSize: parent.height * 0.7

        anchors.centerIn: parent
    }
}
