import QtQuick 2.0

/**
  Button to confirm calculation
  */
FilledClickable {
    id: component

    hoverMaskEnabled: true
    hoverEnabled: true

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
