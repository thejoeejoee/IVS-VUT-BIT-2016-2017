import QtQuick 2.0

Clickable {
    id: component

    property color color
    property color backgroundColor
    property alias text: buttonText.text
    property font font

    hoverEnabled: true

    onEntered: ParallelAnimation {
        ColorAnimation { target: background; property: "border.color"; to: "transparent"; duration: 200 }
        ColorAnimation { target: background; property: "color"; to: component.color; duration: 200 }
        ColorAnimation { target: buttonText; property: "color"; to: component.backgroundColor; duration: 200 }
    }

    onExited: ParallelAnimation {
        ColorAnimation { target: background; property: "border.color"; to: component.color; duration: 200 }
        ColorAnimation { target: background; property: "color"; to: "transparent"; duration: 200 }
        ColorAnimation { target: buttonText; property: "color"; to: component.color; duration: 200 }
    }

    Rectangle {
        id: background

        color: "transparent"
        border.color: component.color
        border.width: 1.5
        anchors.fill: parent
    }

    Text {
        id: buttonText

        color: component.color

        font.pixelSize: parent.height * 0.7
        font.family: component.font.family

        anchors.centerIn: parent
    }
}
