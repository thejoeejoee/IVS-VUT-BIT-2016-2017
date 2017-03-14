import QtQuick 2.0
import "../controls" as Controls

Controls.Clickable {
    id: component

    property alias buttonText: innerText.text;
    property color color: "black"
    property color textColor: "black"
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
