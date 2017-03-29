import QtQuick 2.7
import Calculator 1.0

/**
  Display result of calculation in different bases
  */
Rectangle {
    id: component

    /// List of bases to be displayed
    property var bases
    /// Value which will be converted to different bases
    property real value: 0
    /// Used font
    property font font
    /// Text color of base name
    property color baseTextColor
    /// Text color of converted value
    property color valueTextColor
    /// Color of value scrollbar
    property color scrollbarColor
    /// Margin of text
    readonly property int margin: 10

    Column {
        id: container

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: component.margin
        anchors.bottomMargin: component.margin
        anchors.leftMargin: component.margin * 2

        Repeater {
            model: Object.keys(component.bases)
            Item {
                width: container.width
                height: container.height / Object.keys(component.bases).length

                Text {
                    id: baseText

                    text: modelData
                    color: component.baseTextColor

                    font.pixelSize: parent.height * 0.9
                    font.family: component.font.family

                    anchors.top: parent.top
                    anchors.left: parent.left
                }

                FontMetrics {
                    id: fm
                    font: baseText.font
                }

                Rectangle {
                    color: component.scrollbarColor
                    opacity: (flick.visibleArea.widthRatio != 1 && flick.moving)

                    x: flick.width * flick.visibleArea.xPosition + flick.x
                    width: flick.width * flick.visibleArea.widthRatio
                    height: 2

                    anchors.top: flick.bottom
                    anchors.topMargin: height

                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }
                }

                Flickable {
                    id: flick

                    boundsBehavior: Flickable.StopAtBounds
                    flickableDirection: Flickable.HorizontalFlick
                    clip: true

                    width: parent.width - anchors.leftMargin
                    height: parent.height

                    contentHeight: valueText.height
                    contentWidth: valueText.width

                    anchors.left: parent.left
                    anchors.leftMargin: component.margin * 3 + fm.advanceWidth("DEC")   // some constant to measure font width

                    AnimatedText {
                        id: valueText
                        text: Calculator.convertToBase(component.value, component.bases[modelData])
                        color: component.valueTextColor
                        font: baseText.font
                    }
                }
            }
        }
    }
}
