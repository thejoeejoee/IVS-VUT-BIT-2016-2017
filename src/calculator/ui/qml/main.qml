import QtQuick 2.7
import QtQuick.Controls 1.4
// TODO allow
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

    VariablesPanel {
        id: variablePanel

        backgroundColor: StyleSettings.variablesPanel.backgroundColor
        textColor: StyleSettings.variablesPanel.textColor
        identifierTextColor: StyleSettings.variablesPanel.identifierColor
        scrollBarColor: StyleSettings.variablesPanel.scrollBarColor

        ansTextColor: StyleSettings.ans.textColor
        ansIdentifierTextColor: StyleSettings.ans.identifierColor
        ansColor: StyleSettings.ans.backgroundColor

        font.family: StyleSettings.variablesPanel.font.family

        width: parent.width / 3.2
        height: parent.height
        itemHeight: parent.height / 6

        anchors.top: parent.top
        anchors.right: parent.right

        onDeleteVariableRequest: Calculator.removeVariable(identifier)
        onSetVariableRequest: Calculator.setVariableValue(identifier, value)
    }

    FunctionsPanel {
        id: functionPanel

        items: Calculator.builtinFunctions
        columns: 1
        backgroundColor: StyleSettings.functionPanel.backgroundColor
        textColor: StyleSettings.functionPanel.textColor
        hoverTextColor: StyleSettings.functionPanel.hoverTextColor

        height: parent.height * 0.45
        width: parent.width / 15.7

        anchors.left: parent.left
        anchors.bottom: parent.bottom

        onClicked: {
            var expansion = Calculator.builtinFunctionsExpansion[func]
            expInput.text += expansion
            expInput.cursorPosition = expInput.text.length
        }
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

        onConfirmed: Calculator.process(expInput.text)
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
        if(typeof data["result"] !== "undefined")
            resultDisplay.result = data["result"]

        var variablesDiff = data["variablesDiff"]["new"].concat(data["variablesDiff"]["modified"])
        var variables = data["variables"]

        for(var key in variablesDiff) {
            var identifier = variablesDiff[key]
            variablePanel.handleVariableAction(identifier, variables[identifier].expression, variables[identifier].value)
        }
    }

}
