import QtQuick 2.7
import QtQuick.Controls 1.4
//import ExpSyntaxHighlighter 1.0
import Sides 1.0
import Calculator 1.0
import StyleSettings 1.0

import "controls" as Control
import "../easteregg"
import "loaders" as Loaders

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

        color: StyleSettings.ans.backgroundColor
        textColor: StyleSettings.ans.textColor
        identifierTextColor: StyleSettings.ans.identifierColor

        variableIdentifier: "Ans"
        variableExpression: variableValue
        variableValue: 0

        width: parent.width / 3.2
        height: parent.height / 6

        font.family: StyleSettings.ans.font.family

        anchors.right: parent.right
    }

    VariablesPanel {
        id: variablePanel

        backgroundColor: StyleSettings.variablesPanel.backgroundColor
        textColor: StyleSettings.variablesPanel.textColor
        identifierTextColor: StyleSettings.variablesPanel.identifierColor
        scrollBarColor: StyleSettings.variablesPanel.scrollBarColor

        font.family: StyleSettings.variablesPanel.font.family

        width: ans.width
        height: parent.height
        itemHeight: ans.height

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
        width: parent.width / 15.7

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
        anchors.right: calculateButton.left
    }

    ResultDisplay {
        id: resultDisplay

        color: StyleSettings.resultDisplay.backgroundColor
        textColor: StyleSettings.resultDisplay.textColor
        font.family: StyleSettings.resultDisplay.font.family

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: variablePanel.left
        anchors.bottom: functionPanel.top
    }

    Control.CalculateButton {
        id: calculateButton

        width: parent.width / 14

        color: StyleSettings.calculateButton.backgroundColor

        anchors.top: expInput.top
        anchors.bottom: parent.bottom
        anchors.right: variablePanel.left

        onClicked: {
            Calculator.process(expInput.text)
        }
    }

    Component.onCompleted: {
        Calculator.processed.connect(handleResult)
    }

    function handleResult(data) {
        console.log(data)
        resultDisplay.result = data["result"]
    }
}
