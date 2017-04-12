import QtQuick 2.0
import "../controls" as Controls

/**
  Button with label and simple animation
  */
FilledClickable {
    id: component

    /// Label of button
    property alias buttonText: innerText.text;
    /// Text color
    property color textColor

    hoverMaskEnabled: true
    hoverEnabled: true

    Text {
        id: innerText

        color: textColor

        font.family: "Roboto Light"
        font.pixelSize: component.height * 0.55

        anchors.centerIn: parent
    }
}
