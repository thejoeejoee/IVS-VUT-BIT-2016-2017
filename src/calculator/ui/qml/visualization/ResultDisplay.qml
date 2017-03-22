import QtQuick 2.0

Rectangle {
    id: component

    property alias result: text.text
    property alias textColor: text.color
    property font font

    AnimatedText {
        id: text

        font.family: component.font.family
        font.pixelSize: parent.height / 1.9

        anchors.right: parent.right
        anchors.rightMargin: font.pixelSize / 3.4
        anchors.bottom: parent.bottom
    }
}
