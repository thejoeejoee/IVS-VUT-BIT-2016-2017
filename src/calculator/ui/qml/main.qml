import QtQuick 2.7
import QtQuick.Controls 1.4
//import ExpSyntaxHighlighter 1.0
import "window" as Window
import Sides 1.0
import StyleSettings 1.0
import "controls" as Control

import "../easteregg"
import "loaders" as Loaders

// TODO delete
import "containers"
import "visualization"

ApplicationWindow {
    id: mainWindow

    width: 1101
    minimumHeight: width * (522 / 1101)
    maximumHeight: minimumHeight

    //flags: Qt.FramelessWindowHint
    title: qsTr("Barbie Calculator")
    visible: true

    /*Item{
        Game {
            id: game

            Component.onCompleted: game.run()
            onGameOver: console.log(msg)
        }
    }*/

//    Item {
//        ExpSyntaxHighlighter {
//            id: esh
//            target: te
//        }
//    }

    Loaders.FontsLoader {}

    VariableDisplay {
        id: ans

        color: "#C1C0C0"
        identifierTextColor: "black"
        textColor: "white"

        variableIdentifier: "Ans"
        variableExpression: variableValue
        variableValue: 0

        width: v.width
        height: 29 * 3

        anchors.right: parent.right
    }

    VariablesPanel {
        id: v
        width: 340
        height: parent.height

        textColor: "white"
        identifierTextColor: "#ED1946"

        itemHeight: 29 * 3

        anchors.top: ans.bottom
        anchors.right: parent.right
    }

    FunctionsPanel {
        id: functionPanel

        items: ["pow", "root", "fact", "rand", "log", "e", "pi"]
        columns: 1
        backgroundColor: StyleSettings.functionPanel.backgroundColor
        textColor: StyleSettings.functionPanel.textColor
        hoverTextColor: StyleSettings.functionPanel.hoverTextColor

        height: parent.height * 0.45
        width: 70

        anchors.left: parent.left
        anchors.bottom: parent.bottom

        onClicked: console.log(func)
    }

    Control.ExpressionInput {
        id: expInput

        focus: true
        style: StyleSettings.expressionInput.style
        placeholderTextColor: StyleSettings.expressionInput.placeholderTextColor

        font.family: StyleSettings.expressionInput.font
        font.pixelSize: height / 7

        anchors.left: functionPanel.right
        anchors.top: functionPanel.top
        anchors.bottom: parent.bottom
        anchors.right: v.left
    }
}
