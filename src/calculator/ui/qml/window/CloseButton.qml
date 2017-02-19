import QtQuick 2.0
import QtQuick.Window 2.0
import "../controls" as Controls

Controls.Clickable {
    property Window target

    onClicked: target.close()

    Rectangle {
        color: "#C72026"
        anchors.fill: parent

        Image {
            source: "qrc:/assets/images/cross.svg"

            scale: 0.65
            antialiasing: true
            anchors.centerIn: parent

            sourceSize.width: parent.width
            sourceSize.height: parent.height
        }
    }
}
