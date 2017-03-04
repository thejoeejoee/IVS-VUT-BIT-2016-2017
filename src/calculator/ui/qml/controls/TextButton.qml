import QtQuick 2.0
import "../controls" as Controls

Controls.Clickable {
    id: button
    property alias buttonText: innerText.text;
    property color color: "black"
    property color hoverColor: "grey"
    property color textColor: "black"
    property color hoverTextColor: "white"

    hoverEnabled: true
    onEntered: { button.state='Hovering'}
    onExited: { button.state=''}

    anchors.fill: parent
    onEnabledChanged: state = ""

    Rectangle {
        id: rectangleButton
        anchors.fill: parent
        color: button.color
    }

    Text {
        id: innerText
        anchors.centerIn: rectangleButton
        color: textColor
        font.pixelSize: button.height * 0.43
        font.family: "Roboto Light"
    }

    states: State {
        name: "Hovering"
        PropertyChanges {
            target: rectangleButton
            color: hoverColor
        }
        PropertyChanges {
            target: innerText
            color: hoverTextColor
        }
    }

    transitions: Transition {
        from: ""; to: "Hovering"
        reversible: true
        ColorAnimation { duration: 200 }
    }
}
