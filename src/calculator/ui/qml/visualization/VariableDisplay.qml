import QtQuick 2.0

Rectangle {
    id: component

    property color textColor
    property color identifierTextColor
    property string variableIdentifier: ""
    property string variableExpression: ""
    property real variableValue: 0
    property font font

    QtObject {
        id: internal

        property real sideMargin: height / 6.5
    }

    // display expression and variable name
    Item {
        height: parent.height * 0.9

        anchors.leftMargin: internal.sideMargin
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        Text {
            antialiasing: true
            text: component.variableIdentifier
            color: component.identifierTextColor

            font.family: component.font.family
            font.pixelSize: parent.height * 0.58

            anchors.bottom: parent.bottom
            anchors.left: parent.left
        }

        AnimatedText {
            antialiasing: true
            text: component.variableExpression
            color: component.textColor

            font.family: component.font.family
            font.pixelSize: parent.height * 0.25

            anchors.left: parent.left
            anchors.top: parent.top
        }
    }

    // value display
    AnimatedText {
        text: component.variableValue
        color: component.textColor

        font.family: component.font.family
        font.pixelSize: parent.height * 0.7

        anchors.right: parent.right
        anchors.rightMargin: internal.sideMargin
        anchors.verticalCenter: parent.verticalCenter
    }
}
