import QtQuick 2.0

/**
  Base component for all mouse interactive components
  */
Item {
    id: component

    /**
      Emits when clicked on component
      @param pos Position of click
      */
    signal clicked(point pos)
    /**
      Emits when mouse entered area of component
      */
    signal entered()
    /**
      Emits when mouse leaved area of component
      */
    signal exited()
    /**
      Emits after mouse is pressed
      */
    signal pressed()
    /**
      Emits after mouse is released
      */
    signal released()

    /// If set to true hover is enabled else disable hover
    property alias hoverEnabled: mouseArea.hoverEnabled
    /// Holds whether component is hovered
    readonly property alias hovered: mouseArea.containsMouse

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onPressed: component.pressed()
        onReleased: component.released()
        onClicked: component.clicked(Qt.point(mouse.x, mouse.y))
        onContainsMouseChanged: {
            if(mouseArea.containsMouse)
                component.entered()
            else
                component.exited()
        }
    }
}
