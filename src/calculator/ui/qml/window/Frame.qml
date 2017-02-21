import QtQuick 2.0
import QtQuick.Window 2.0

Rectangle {
    id: component

    property Window window
    property Component title
    property Component icon
    property Component buttons

    Loader {
        id: titleLoader

        sourceComponent: component.title
        width: parent.width // TODO - close button width
        height: parent.height

        anchors.left: icon.right
        anchors.right: parent.right
    }

    Loader {
        id: icon

        sourceComponent: component.icon
        width: height
        height: parent.height

        anchors.left: parent.left
        anchors.top: parent.top
    }

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

    Loader {
        id: buttons

        sourceComponent: component.buttons

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }
}
