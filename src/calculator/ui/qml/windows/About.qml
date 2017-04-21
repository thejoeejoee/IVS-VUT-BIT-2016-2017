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
import QtQuick 2.5
import QtQuick.Window 2.0
import QtQuick.Controls 1.4

/**
  Component which displays info about Calculator app
  */
Item {
    id: component

    /**
      Used as function to display component
      */
    signal show
    /**
      Used as function to hide component
      */
    signal hide
    /**
      Emit after component is not visible anymore
      */
    signal hidden

    /// Padding of text in component
    property int padding: 20
    /// Revision from which is app released
    property string revision
    /// Background color of component
    property color color: "black"
    /// Text color
    property color textColor: "lightGray"
    /// Text color of title
    property alias titleColor: title.color
    /// Used font
    property font font

    visible: opacity
    focus: visible
    opacity: 0

    onShow: NumberAnimation { target: component; property: "opacity"; to: 1; duration: 200 }
    onHide: SequentialAnimation {
        NumberAnimation { target: component; property: "opacity"; to: 0; duration: 200 }
        ScriptAction { script: { component.hidden() } }
    }

    Keys.onEscapePressed: component.hide()

    MouseArea {
        anchors.fill: parent
        onClicked: component.hide()
    }

    Rectangle {
        color: component.color
        opacity: 0.8
        anchors.fill: parent
    }

    Rectangle {
        color: component.color

        width: 360
        height: 260

        anchors.centerIn: parent


        Image {
            source: "qrc:/assets/images/logo.svg"
            fillMode: Image.PreserveAspectFit
            opacity: 0.2

            width: parent.width * 0.7
            height: parent.height * 0.7

            sourceSize.width: width
            sourceSize.height: height

            anchors.centerIn: parent
        }

        Text {
            id: title

            text: qsTr("Calculator") + " " + "1.0rc1-1"

            font.pixelSize: 25
            font.family: component.font.family

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: component.padding
            anchors.leftMargin: component.padding
        }

        Text {
            color: component.textColor
            font.pixelSize: 15
            font.family: component.font.family

            anchors.left: title.left
            anchors.top: title.bottom

            text: qsTr("From revision") + " - " + component.revision + "\n\n" +
                       qsTr("Created by:") + "\n" +
                       "    Josef Kolář\n" +
                       "    Son Hai Nguyen\n" +
                       "    Martin Omacht\n" +
                       "    Robert Navrátil\n\n" +
                       "Copyright 2016-2017 Syan Entertainment.\n" +
                       qsTr("All rights reserved.")
        }
    }
}
