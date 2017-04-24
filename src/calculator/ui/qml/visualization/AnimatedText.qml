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
import QtQuick 2.7

/**
  Animate change of text
  */
Item {
    id: component

    /// Text to be displayed
    property string text: ""
    /// Font of text
    property font font: Qt.font()
    /// Text color
    property color color: "black"

    width: baseText.width
    height: baseText.height

    onTextChanged: SequentialAnimation {
        NumberAnimation { target: baseText; property: "opacity"; duration: 120; to: 0 }
        ScriptAction { script: { baseText.text = component.text }}
        NumberAnimation { target: maskedText; property: "opacity"; duration: 120; to: 1 }
        ScriptAction { script: {
            baseText.opacity = 1
            maskedText.opacity = 0
        }}
    }

    Text {
        id: baseText

        color: component.color
        font: component.font
        textFormat: Text.RichText

        anchors.top: parent.top
        anchors.left: parent.left
    }

    Text {
        id: maskedText

        text: component.text
        color: component.color
        opacity: 0
        font: component.font
        textFormat: Text.RichText

        anchors.top: parent.top
        anchors.left: parent.left
    }
}
