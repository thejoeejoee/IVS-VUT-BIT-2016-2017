import QtQuick 2.0
import "../controls" as Controls

/**
  Menu with variable actions
  */
Item {
    id: component

    /**
      Emits after clicking on setter
      @param value Value requested to be set
      */
    signal valueSetRequest(int value)
    /**
      Emits after clicking on delete button
      */
    signal deleteRequest()

    /// Holds current width of menu(dynamically changes)
    readonly property alias menuWidth: dots.width
    /// Sets true if menu is running show animation
    readonly property alias animationRunning: xAnimation.running
    /// Background color of dots(area to slide up menu)
    property alias dotsBackgroundColor: dotsBackground.color
    /// Background color of remove button
    property alias removeButtonColor: removeButtonBackground.color
    /// Background color of setters
    property color settersColor
    /// Background color of setters when hovered
    property color settersHoveredColor
    /// Text color of setters
    property color settersTextColor
    /// Font of component
    property font font

    state: "hidden"

    states: [
        State {
            name: "showed"
            PropertyChanges { target: component; anchors.leftMargin: -component.width }
        },
        State {
            name: "hidden"
            PropertyChanges { target: component; anchors.leftMargin: -dots.width }
        }
    ]

    transitions: Transition {
        NumberAnimation { id: xAnimation; property: "anchors.leftMargin"; duration: 400; easing.type: Easing.InOutQuad }
    }

    QtObject {
        id: internal

        readonly property bool menuVisible: (component.anchors.leftMargin == -component.width)
        readonly property bool menuContainMouse: (dots.hovered || zeroSetter.hovered ||
                                         oneSetter.hovered || removeButton.hovered ||
                                         mouseAreaOverlay.containsMouse)
    }

    // ----- DOTS -----
    Controls.Clickable {
        id: dots

        hoverEnabled: true
        width: parent.width * 0.12
        height: parent.height

        Rectangle {
            id: dotsBackground
            anchors.fill: parent
        }

        Image {
            source: "qrc:/assets/images/dots.svg"
            fillMode: Image.PreserveAspectFit
            width: parent.width / 3
            height: parent.height

            sourceSize.width: parent.width
            sourceSize.height: parent.height

            anchors.centerIn: parent
        }
    }

    // ----- SET BUTTONS -----
    Column{
        id: setters

        width: parent.width  * 0.65
        height: parent.height

        anchors.top: parent.top
        anchors.left: dots.right

        Controls.VariableSetButton {
            id: zeroSetter

            width: parent.width
            height: parent.height / 2

            value: 0
            color: component.settersColor
            hoverColor: component.settersHoveredColor
            textColor: component.settersTextColor
            font: component.font
        }

        Controls.VariableSetButton {
            id: oneSetter

            width: parent.width
            height: parent.height / 2

            value: 1
            color: component.settersColor
            hoverColor: component.settersHoveredColor
            textColor: component.settersTextColor
            font: component.font
        }
    }

    // ----- REMOVE BUTTON -----
    Controls.Clickable {
        id: removeButton

        hoverEnabled: true
        width: parent.width - dots.width - setters.width
        height: parent.height

        anchors.left: setters.right

        Rectangle {
            id: removeButtonBackground
            anchors.fill: parent
        }

        Image {
            source: "qrc:/assets/images/trash.svg"
            fillMode: Image.PreserveAspectFit
            antialiasing: true
            smooth: true
            width: parent.width * 0.7
            height: parent.height

            sourceSize.width: parent.width
            sourceSize.height: parent.height

            anchors.centerIn: parent
        }
    }

    // overlay for smooth animation
    MouseArea {
        id: mouseAreaOverlay

        width: (internal.menuVisible) ?0 :component.width
        height: parent.height
        hoverEnabled: true
    }

    Connections {
        target: removeButton
        onClicked: component.deleteRequest()
    }

    Connections {
        target: zeroSetter
        onClicked: component.valueSetRequest(zeroSetter.value)
    }

    Connections {
        target: oneSetter
        onClicked: component.valueSetRequest(oneSetter.value)
    }

    Connections {
        target: internal

        onMenuContainMouseChanged: {
            if(internal.menuContainMouse)
                component.state = "showed"
            else
                component.state = "hidden"
        }
    }
}
