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
  Base component for all mouse interactive components
  */
Item {
    id: component

    /**
      Emits when clicked on component
      @param mouse Contains event data
      */
    signal clicked(var mouse)
    /**
      Emits when mouse entered area of component
      */
    signal entered()
    /**
      Emits when mouse leaved area of component
      */
    signal exited()
    /**
      Emits after mouse is pressed
      @param mouse Contains event data
      */
    signal pressed(var mouse)
    /**
      Emits after mouse is released
      @param mouse Contains event data
      */
    signal released(var mouse)

    /// If set to true hover is enabled else disable hover
    property alias hoverEnabled: mouseArea.hoverEnabled
    /// Holds whether component is hovered
    readonly property alias hovered: mouseArea.containsMouse
    /// Sets to manual signal emitting
    property bool manual: false
    /// Expose MouseArea
    readonly property alias mouseArea: mouseArea

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed: {
            if(!component.manual)
                component.pressed(mouse)
        }

        onReleased: {
            if(!component.manual)
                component.released(mouse)
        }

        onClicked: {
            if(!component.manual)
                component.clicked(mouse)
        }

        onContainsMouseChanged: {
            if(component.manual)
                return
            if(mouseArea.containsMouse)
                component.entered()
            else
                component.exited()
        }
    }
}
