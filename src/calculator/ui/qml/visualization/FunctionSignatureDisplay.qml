import QtQuick 2.0

/**
  Component to display function signature
  */
Rectangle {
    id: component

    /**
      Used as function to display component
      @param signature Signature to display
      */
    signal show(string signature)
    /**
      Used as function to hide component
      */
    signal hide()

    /// Contains function signature in string
    property alias text: text.text
    /// Text color display
    property alias textColor: text.color
    /// Used font
    property font font

    width: text.width + height * 0.2

    Text {
        id: text

        font.family: component.font.family
        font.pixelSize: parent.height * 0.7

        anchors.centerIn: parent
    }
}
