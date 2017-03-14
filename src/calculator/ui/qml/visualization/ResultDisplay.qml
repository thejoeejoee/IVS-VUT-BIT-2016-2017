import QtQuick 2.0

Rectangle {
    id: component

    property alias result: text.text
    property alias textColor: text.color
    property font font

    Text {
        id: text

        font.family: component.font.family
        font.pixelSize: parent.height / 3.8

        anchors.right: parent.right
        anchors.rightMargin: font.pixelSize / 1.8
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height / 20
    }
}
