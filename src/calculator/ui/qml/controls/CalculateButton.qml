import QtQuick 2.0

Clickable {
    property alias color: background.color

    Rectangle {
        id: background
        anchors.fill: parent
    }

    Image {
        source: "qrc:/assets/images/equal.svg"

        fillMode: Image.PreserveAspectFit
        width: parent.width / 2.2

        sourceSize: Qt.size(400, 400)

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.centerIn: parent
    }
}
