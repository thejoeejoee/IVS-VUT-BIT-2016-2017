import QtQuick 2.0

Item {
    id: component

    signal clicked(point pos)
    signal entered()
    signal exited()

    property alias hoverEnabled: mouseArea.hoverEnabled
    readonly property alias hovered: mouseArea.containsMouse

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: component.clicked(Qt.point(mouse.x, mouse.y))
        onContainsMouseChanged: {
            if(mouseArea.containsMouse)
                component.entered()
            else
                component.exited()
        }
    }
}
