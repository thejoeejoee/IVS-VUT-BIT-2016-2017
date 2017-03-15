import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

TextArea {
    id: expInput

    signal confirmed()
    property alias placeholderTextColor: placeholderText.color

    focus: true
    textMargin: 15
    antialiasing: true
    frameVisible: false

    Keys.onReturnPressed: {
        expInput.confirmed()
        event.accepted = true
    }

    Text {
        id: placeholderText

        text: qsTr("Enter expression...")
        font: expInput.font
        opacity: (expInput.text) ?0 :0.8

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: expInput.textMargin
        anchors.topMargin: expInput.textMargin

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
}
