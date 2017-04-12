import QtQuick 2.7

/**
  Animate change of text
  */
Item {
    id: component

    /// Text to be displayed
    property string text: ""
    /// Font of text
    property font font: Qt.font()
    /// Text color
    property color color: "black"

    width: baseText.width
    height: baseText.height

    onTextChanged: SequentialAnimation {
        NumberAnimation { target: baseText; property: "opacity"; duration: 120; to: 0 }
        ScriptAction { script: { baseText.text = component.text }}
        NumberAnimation { target: maskedText; property: "opacity"; duration: 120; to: 1 }
        ScriptAction { script: {
            baseText.opacity = 1
            maskedText.opacity = 0
        }}
    }

    Text {
        id: baseText

        color: component.color
        font: component.font
        textFormat: Text.RichText

        anchors.top: parent.top
        anchors.left: parent.left
    }

    Text {
        id: maskedText

        text: component.text
        color: component.color
        opacity: 0
        font: component.font
        textFormat: Text.RichText

        anchors.top: parent.top
        anchors.left: parent.left
    }
}
