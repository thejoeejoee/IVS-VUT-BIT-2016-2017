import QtQuick 2.7
import Calculator 1.0

/**
  Display result of calculation in different bases
  */
Rectangle {
    id: component

    /// Ordered list of bases to be displayed
    property var basesList
    /// Dict of bases with number base to be displayed
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
    /// Prompter of value flickable theme
    property string prompterTheme

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
            model: component.basesList
            Item {
                width: container.width
                height: container.height / component.basesList.length

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
                    opacity: (valueText.flick.visibleArea.widthRatio != 1 && valueText.flick.moving)

                    x: valueText.width * valueText.flick.visibleArea.xPosition + valueText.x
                    width: valueText.width * valueText.flick.visibleArea.widthRatio
                    height: 2

                    anchors.top: valueText.bottom
                    anchors.topMargin: height

                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }
                }

                FlickableAnimatedText {
                    id: valueText

                    text: Calculator.convertToBase(component.value, component.bases[modelData])
                    color: component.valueTextColor
                    font: baseText.font
                    theme: component.prompterTheme

                    width: parent.width - anchors.leftMargin
                    height: parent.height

                    anchors.left: parent.left
                    anchors.leftMargin: component.margin * 3 + fm.advanceWidth("DEC")   // some constant to measure font width
                }
            }
        }
    }
}
