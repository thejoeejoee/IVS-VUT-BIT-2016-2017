import QtQuick 2.0

Rectangle {
    id: component

    /**
      Emits request to expand text by variable data
      @param data String requested to be expanded
      */
    signal expandRequest(string data)
    /**
      Emits request to overwrite text by variable data
      @param data String requested to be expanded
      */
    signal overwriteRequest(string data)

    /// Text color
    property color textColor
    /// Text color of identifier
    property color identifierTextColor
    /// Background color of expression when hovered
    property color expressionHoverColor
    /// Variable identifier
    property string variableIdentifier: ""
    /// Variable expression
    property string variableExpression: ""
    /// Variable value
    property string variableValue: "0"
    /// Used font
    property font font

    QtObject {
        id: internal

        property real sideMargin: height / 6.5
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if(mouse.button == Qt.LeftButton)
                component.expandRequest(component.variableIdentifier)
            else
                component.overwriteRequest(component.variableIdentifier + ' ' + component.variableExpression)
        }
    }

    Rectangle {
        id: expressionBackground

        color: "transparent"

        width: component.width
        height: expression.y + expression.height + leftSide.y
        anchors.top: parent.top

        Behavior on color {
            ColorAnimation { duration: 300 }
        }
    }

    // display expression and variable name
    Item {
        id: leftSide

        height: parent.height * 0.92

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
            id: expression

            antialiasing: true
            text: component.variableExpression
            color: component.textColor

            font.family: component.font.family
            font.pixelSize: parent.height * 0.23

            anchors.left: parent.left
            anchors.top: parent.top

            MouseArea {
                hoverEnabled: true
                width: component.width

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                onClicked: {
                    if(component.variableExpression.indexOf("=") != -1)
                        component.overwriteRequest(component.variableIdentifier + ' ' + component.variableExpression)
                    else
                        component.overwriteRequest(component.variableExpression)
                }
                onContainsMouseChanged: {
                    if(containsMouse)
                        expressionBackground.color = component.expressionHoverColor
                    else
                        expressionBackground.color = "transparent"
                }
            }
        }
    }

    // value display
    AnimatedText {
        text: component.variableValue
        color: component.textColor

        font.family: component.font.family
        font.pixelSize: parent.height * 0.55

        anchors.right: parent.right
        anchors.rightMargin: internal.sideMargin
        anchors.bottom: leftSide.bottom
    }
}
