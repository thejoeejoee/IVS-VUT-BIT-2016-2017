import QtQuick 2.0

/**
  Specialized component to show calculation result
  */
Rectangle {
    id: component

    /// Result to be displayed
    property alias result: text.text
    /// Text color
    property alias textColor: text.color
    /// Used font
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
