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
import QtQuick.Controls 2.0
import "../../assets/contents/help.js" as HelpContent

/**
  Component to display help content.
  */
ApplicationWindow {
    id: window

    /// Color of content text
    property alias textColor: text.color
    /// Text color of title
    property color titleColor
    /// Text color of subtitle
    property color subtitleColor
    /// Used font
    property font textFont
    /// Color of scrollbar
    property alias scrollBarColor: scrollBar.color

    title: qsTr("Help")
    visible: false

    Flickable {
        id: flick

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        contentWidth: width
        contentHeight: text.height

        anchors.fill: parent

        Text {
            id: text

            readonly property string style: '<style>
                    .title {
                        color: %1;
                        font-size: %6px;
                    }
                    .subtitle { color: %2; }
                    body {
                        margin-left: %3px;
                    }
                    p, .subtitle {
                        margin-left: %4px;
                        font-size: %5px;
                    }
            </style>'
            .arg(titleColor)
            .arg(subtitleColor)
            .arg(15)    // body margin
            .arg(10)    // text margins
            .arg(15)    // text font size
            .arg(20)    // title font size

            width: parent.width - 7
            textFormat: Text.RichText
            wrapMode: TextEdit.WordWrap
            text: ''
            font.family: window.font.family

            Component.onCompleted: {
                var content = ""

                for(var key in HelpContent.content) {
                    var section = HelpContent.content[key]

                    if(typeof section["title"] != "undefined")
                        content += '<p class="title"><b>%1</b></p>'.arg(section["title"])
                    if(typeof section["subtitle"] != "undefined")
                        content += '<p class="subtitle">%1</p>'.arg(section["subtitle"])
                    if(typeof section["content"] != "undefined")
                        content += "<p>%1</p>".arg(section["content"])
                }
                text.text += "%1<body>%2</body>".arg(text.style).arg(content)
            }
        }
    }

    Rectangle {
        id: scrollBar

        opacity: (flick.visibleArea.heightRatio === 1) ?0 :1

        y: flick.visibleArea.yPosition * flick.height
        width: 3
        height: flick.visibleArea.heightRatio * flick.height

        anchors.right: parent.right

        Behavior on opacity {
            NumberAnimation { duration: 400 }
        }
    }
}
