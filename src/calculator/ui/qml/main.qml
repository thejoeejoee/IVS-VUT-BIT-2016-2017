import QtQuick 2.7
import QtQuick.Controls 1.4
import "window" as Window

ApplicationWindow {
    id: mainWindow
    width: 640
    height: 480
    flags: Qt.FramelessWindowHint
    visible: true

    Item {
        id: root
        anchors.fill: parent
    }

    Window.Frame {
        width: parent.width
        height: 10
        color: "gray"
        window: mainWindow

        anchors.top: root.top
        anchors.left: root.left
    }
}
