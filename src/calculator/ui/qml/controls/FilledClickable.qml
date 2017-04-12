import QtQuick 2.0

/**
  Base component for all buttons with background
  */
Clickable {
    id: component

    /// Background color
    property alias color: background.color
    /// Background color of mask when button is hovered
    property alias hoverColor: mask.color
    /// If true mask is applied when hovered
    property alias hoverMaskEnabled: mask.visible

    Rectangle {
        id: background
        anchors.fill: parent
    }

    Rectangle {
        id: mask

        opacity: 0
        visible: false

        anchors.fill: parent
    }

    hoverEnabled: true
    onPressed: mask.opacity = 0.2
    onReleased: {
        if(component.hovered)
            mask.opacity = 0.1
    }

    onEntered: mask.opacity = 0.1
    onExited: mask.opacity = 0
}
