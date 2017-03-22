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

                AnimatedText {
                    text: Calculator.convertToBase(component.value, component.bases[modelData])
                    color: component.valueTextColor
                    font: baseText.font

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: component.margin * 3 + fm.advanceWidth("DEC")   // some constant to measure font width

                    FontMetrics {
                        id: fm
                        font: baseText.font
                    }
                }
            }
        }
    }
}
