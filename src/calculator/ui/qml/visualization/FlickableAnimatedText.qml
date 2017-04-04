import QtQuick 2.0

/**
  Text with ability of flicking.
  */
Flickable {
    id: component

    /// Displayed text
    property alias text: text.text
    /// Text Color
    property alias color: text.color
    /// Used font
    property alias font: text.font

    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.HorizontalFlick
    clip: true

    contentHeight: text.height
    contentWidth: text.width

    AnimatedText {
        id: text
    }
}
