import QtQuick 2.0
import QtQuick.Controls 1.4

ApplicationWindow {
    id: window

    default property alias content: container.children

    flags: Qt.FramelessWindowHint
    visible: true

    Item {
        id: container

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: frame.bottom
    }

    Frame {
        id: frame

        height: 30
        color: "#2F2F2F"
        window: window

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.left: parent.left

        title: Item {
            Label {
                color: "white"
                text: qsTr("Barbie Calculator")

                anchors.verticalCenter: parent.verticalCenter
            }
        }

        buttons: CloseButton {
            width: height
            target: window
        }
    }
}
