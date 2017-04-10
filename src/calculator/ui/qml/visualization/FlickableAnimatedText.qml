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
        opacity: (prompter.width > 0 && flick.visibleArea.widthRatio != 1) ?0.8 :0
        visible: opacity

        width: height * 3 - flick.contentX
        height: fontMetrics.height * 0.8
        radius: 3       

        anchors.verticalCenter: flick.verticalCenter
        anchors.right: flick.right
        anchors.rightMargin: flick.contentX

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        FontMetrics {
            id: fontMetrics
            font: component.font
        }

        Item {
            height: parent.height
            width: arrow.paintedWidth + slideText.anchors.leftMargin + fontMetrics.advanceWidth(slideText.text)
            anchors.centerIn: parent

            Image {
                id: arrow

                source: (component.theme == "dark") ?"qrc:/assets/images/arrow_left_light.svg"
                                                    :"qrc:/assets/images/arrow_left_dark.svg"
                fillMode: Image.PreserveAspectFit

                //width: height
                height: parent.height * 0.6

                //sourceSize.width: width
                sourceSize.height: height

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }

            Text {
                id: slideText

                text: qsTr("Slide")
                color: (component.theme == "dark") ?"white"
                                                   :"black"

                font.family: "Roboto Light"
                font.pixelSize: parent.height * 0.9

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: arrow.right
                anchors.leftMargin: height / 10
            }
        }
    }
}
