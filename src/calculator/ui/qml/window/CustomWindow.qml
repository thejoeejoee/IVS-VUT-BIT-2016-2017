import QtQuick 2.0
import QtQuick.Controls 1.4

ApplicationWindow {
    id: window

    default property alias content: container.children

    flags: Qt.FramelessWindowHint
    visible: true

    Item {
        id: container

        width: parent.width
        height: parent.height - frame.height

        anchors.left: parent.left
        anchors.top: frame.bottom
    }

    Frame {
        id: frame

        width: window.width
        height: 24
        color: "#2F2F2F"
        window: window

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
