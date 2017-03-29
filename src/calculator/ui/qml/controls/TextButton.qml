import QtQuick 2.0
import "../controls" as Controls

/**
  Button with label and simple animation
  */
Controls.Clickable {
    id: component

    /// Label of button
    property alias buttonText: innerText.text;
    /// Background color
    property color color: "black"
    /// Text color
    property color textColor: "black"
    /// text color when hovered
    property color hoverTextColor: "white"

    hoverEnabled: true
    onEntered: innerText.color = hoverTextColor
    onExited: innerText.color = textColor

    Rectangle {
        color: component.color
        anchors.fill: parent
    }

    Text {
        id: innerText

        color: textColor

        font.family: "Roboto Light"
        font.pixelSize: component.height * 0.55

        anchors.centerIn: parent

        Behavior on color {
            ColorAnimation { duration: 300 }
        }
    }

}
