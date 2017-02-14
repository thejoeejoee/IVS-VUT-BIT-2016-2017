import QtQuick 2.0
import QtQuick.Window 2.0

Rectangle {
    id: component

    property Window window

    MouseArea {
        property point startPos
        property bool movingEnabled: false

        hoverEnabled: true
        anchors.fill: parent

        onPressed: {
            startPos = Qt.point(mouse.x, mouse.y)
            movingEnabled = true
        }
        onReleased: movingEnabled = false
        onPositionChanged: {
            if(!movingEnabled)
                return

            component.window.x += mouse.x - startPos.x
            component.window.y += mouse.y - startPos.y
        }
    }
}
