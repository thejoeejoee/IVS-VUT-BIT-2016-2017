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
  Simple countdown display only number of remaining time
  */
Item {
    id: component

    /**
      Start countdown and display component
      @param seconds Count of seconds to be counted down
      */
    signal start(int seconds)
    /**
      Emits after time runs out
      */
    signal triggered()

    /// Holds current remaining time in seconds
    readonly property alias count: timer.count
    /// Text color of numbers
    property alias color: text.color
    /// Font of text
    property font font

    focus: visible
    visible: opacity
    opacity: 0

    onStart: {
        component.opacity = 1
        timer.count = seconds
        timer.start()
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    MouseArea {
        anchors.fill: parent
    }

    Text {
        id: text

        font.pixelSize: parent.height / 1.2
        font.family: component.font.family

        anchors.centerIn: parent
    }

    Timer {
        id: timer

        property int count

        interval: 1000
        running: false
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if(!timer.count) {
                timer.stop()
                component.opacity = 0
                component.triggered()
            }

            else
                text.text = timer.count.toString()
            timer.count--
        }
    }
}
