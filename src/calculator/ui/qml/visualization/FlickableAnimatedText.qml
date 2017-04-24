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
  Text with ability of flicking.
  */

Item {
    id: component

    /// Displayed text
    property alias text: text.text
    /// Text Color
    property alias color: text.color
    /// Used font
    property alias font: text.font
    /// Expose flickable component
    readonly property alias flick: flick
    /// Color type of theme ["light", "dark"]
    property string theme: "dark"

    Flickable {
        id: flick

        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick
        clip: true

        contentHeight: text.height
        contentWidth: text.width

        anchors.fill: parent

        AnimatedText {
            id: text
        }
    }

    Rectangle {
        id: prompter

        color: (component.theme == "dark") ?"black" :"white"
        opacity: (!flick.contentX && flick.visibleArea.widthRatio != 1) ?0.8 :0
        visible: opacity
        clip: true

        width: height * 2.5
        height: fontMetrics.height * 0.8
        radius: 3       

        anchors.verticalCenter: flick.verticalCenter
        anchors.right: flick.right

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        FontMetrics {
            id: fontMetrics
            font: component.font
        }

        Row {
            height: parent.height
            width: height * 0.6 * 4 * (2/5.)
            anchors.centerIn: parent

            Repeater {
                model: 3

                Image {
                    source: (component.theme == "dark") ?"qrc:/assets/images/arrow_left_light.svg"
                                                        :"qrc:/assets/images/arrow_left_dark.svg"
                    fillMode: Image.PreserveAspectFit

                    height: parent.height * 0.6
                    sourceSize.height: height

                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
