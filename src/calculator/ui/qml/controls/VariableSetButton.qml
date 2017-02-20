import QtQuick 2.0
import "../controls" as Controls

Controls.Clickable {
    id: component

    property int value: 0
    property color color
    property color hoverColor
    property color textColor

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

        font.family: "Roboto Light"
        font.pixelSize: parent.height * 0.9

        anchors.centerIn: parent
    }
}
