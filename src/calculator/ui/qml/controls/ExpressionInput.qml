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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

/**
  Specialized input for calculation expression
  */
TextArea {
    id: expInput

    /// Emits after expression was confirmed with enter key
    signal confirmed()
    /// Text color of placeholder
    property alias placeholderTextColor: placeholderText.color

    focus: true
    textMargin: 15
    antialiasing: true
    frameVisible: false
    wrapMode: Text.WordWrap

    Keys.onPressed: {
        if(event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
            expInput.confirmed()
            event.accepted = true
        }
    }

    Text {
        id: placeholderText

        text: qsTr("Enter expression...")
        font: expInput.font
        opacity: (expInput.text) ?0 :0.8

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: expInput.textMargin
        anchors.topMargin: expInput.textMargin

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
}
