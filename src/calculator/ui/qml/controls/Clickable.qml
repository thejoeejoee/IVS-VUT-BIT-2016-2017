import QtQuick 2.0

Item {
    id: component

    signal clicked(point pos)

    MouseArea {
        anchors.fill: parent
        onClicked: component.clicked(Qt.point(mouse.x, mouse.y))
    }
}
