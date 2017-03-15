import QtQuick 2.0

Rectangle {
    id: component

    signal clicked(string identifier)

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

    MouseArea {
        anchors.fill: parent
        onClicked: component.clicked(component.variableIdentifier)
    }

    // display expression and variable name
    Item {
        id: leftSide

        height: parent.height * 0.85

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
        font.pixelSize: parent.height * 0.65

        anchors.right: parent.right
        anchors.rightMargin: internal.sideMargin
        anchors.bottom: leftSide.bottom
    }
}
