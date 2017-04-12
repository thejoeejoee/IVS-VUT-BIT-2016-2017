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
