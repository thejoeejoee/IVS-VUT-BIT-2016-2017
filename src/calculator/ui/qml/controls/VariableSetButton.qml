import QtQuick 2.0
import "../controls" as Controls

/**
  Specialized button to set value to variable
  */
Controls.Clickable {
    id: component

    /// Value which will be set to variable
    property int value: 0
    /// Background color
    property color color
    /// Background color when hovered
    property color hoverColor
    /// Text color
    property color textColor
    /// Font of text
    property font font

    hoverEnabled: true

    onEntered: background.color = component.hoverColor
    onExited: background.color = component.color

    Rectangle {
        id: background

        anchors.fill: parent
        color: component.color

        Behavior on color {
            ColorAnimation { duration: 400 }
        }
    }

    Text {
        text: "=" + component.value
        color: component.textColor

        font.family: component.font.family
        font.pixelSize: parent.height * 0.9

        anchors.centerIn: parent
    }
}
