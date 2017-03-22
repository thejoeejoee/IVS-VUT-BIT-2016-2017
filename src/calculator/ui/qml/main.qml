import QtQuick 2.7
import QtQuick.Controls 1.4
// TODO allow
import ExpSyntaxHighlighter 1.0
import Sides 1.0
import Calculator 1.0
import Expansion 1.0
import Expression 1.0
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

    title: qsTr("Barbie Calculator")
    visible: true

    Game {
        id: game

        onGameOver: console.log(msg)
    }

    ExpSyntaxHighlighter {
        id: esh
        target: expInput

        Component.onCompleted: {
            var rules = Calculator.highlightRules
            for(var key in rules) {
                if(typeof rules[key]["color"] == "object")
                    esh.addHighlightMultiColorRule(rules[key]["pattern"], rules[key]["color"], expInput.font)
                else
                    esh.addHighlightSingleColorRule(rules[key]["pattern"], rules[key]["color"], expInput.font)
            }
        }
    }

    Loaders.FontsLoader {}

    VariablesPanel {
        id: variablePanel

        backgroundColor: StyleSettings.variablesPanel.backgroundColor
        textColor: StyleSettings.variablesPanel.textColor
        identifierTextColor: StyleSettings.variablesPanel.identifierColor
        scrollBarColor: StyleSettings.variablesPanel.scrollBarColor
        expressionHoverColor: StyleSettings.variablesPanel.expressionHoverColor

        ansTextColor: StyleSettings.ans.textColor
        ansIdentifierTextColor: StyleSettings.ans.identifierColor
        ansColor: StyleSettings.ans.backgroundColor
        ansExpressionHoverColor: StyleSettings.ans.expressionHoverColor

        dotsBackgroundColor: StyleSettings.variableItem.dots.color
        removeButtonColor: StyleSettings.variableItem.removeButton.color
        settersColor: StyleSettings.variableItem.setters.color
        settersHoveredColor: StyleSettings.variableItem.setters.hoverColor
        settersTextColor: StyleSettings.variableItem.setters.textColor

        font.family: StyleSettings.variablesPanel.font.family

        width: parent.width / 3.2
        height: parent.height
        itemHeight: parent.height / 6

        anchors.top: parent.top
        anchors.right: parent.right

        onDeleteVariableRequest: Calculator.removeVariable(identifier)
        onSetVariableRequest: Calculator.setVariableValue(identifier, value)
        onExpandRequest: expandExpression(data)
        onOverwriteRequest: overwriteExpression(data)
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

        onExpandRequest: expandExpression(func)
    }

    FontMetrics {
        id: fmExpInput
        font: expInput.font
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

        onConfirmed: {
            if(!completer.visible)
                Calculator.process(expInput.text)
        }
        onTextChanged: {
            if(text.search("nyan") != -1) {
                expInput.text = ""
                game.run()
            }

            completeText()
        }
        onSelectedTextChanged: {
            if(selectedText.length) {
                completer.model = completer.constantModel
                completer.currentText = ""
            }
            else
                completeText()
        }
        onCursorPositionChanged: completeText()
    }

    ResultDisplay {
        id: resultDisplay

        result: "0"
        color: StyleSettings.resultDisplay.backgroundColor
        textColor: StyleSettings.resultDisplay.textColor
        font.family: StyleSettings.resultDisplay.font.family

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: variablePanel.left
        anchors.bottom: resultSystemDisplay.top
    }

    ResultSystemDisplay {
        id: resultSystemDisplay

        value: 0
        bases: { "DEC": 10, "BIN": 2, "HEX": 16, "OCT": 8 }
        height: 100
        baseTextColor: StyleSettings.resultSystemDisplay.baseTextColor
        valueTextColor: StyleSettings.resultSystemDisplay.valueTextColor
        font: StyleSettings.resultSystemDisplay.font

        anchors.bottom: functionPanel.top
        anchors.left: parent.left
        anchors.right: variablePanel.left
    }

    Control.CalculateButton {
        id: calculateButton

        width: parent.width / 14

        color: StyleSettings.calculateButton.backgroundColor

        anchors.top: expInput.top
        anchors.bottom: parent.bottom
        anchors.right: variablePanel.left

        onClicked: Calculator.process(expInput.text)
    }

    Error {
        id: error

        maskColor: StyleSettings.errorDialog.maskColor
        dialogColor: StyleSettings.errorDialog.color
        textColor: StyleSettings.errorDialog.textColor
        font: StyleSettings.errorDialog.font

        anchors.fill: parent

        onHidden: expInput.focus = true
    }

    Component.onCompleted: {
        Calculator.processed.connect(handleResult)
        Calculator.error.connect(error.show)
    }

    Control.Completer {
        id: completer

        target: expInput
        constantModel: Calculator.identifiersTypes

        color: StyleSettings.completer.color
        hoverColor: StyleSettings.completer.hoverColor
        textColor: StyleSettings.completer.textColor
        scrollBarColor: StyleSettings.completer.scrollBarColor

        width: parent.width * 0.18
        itemHeight: width / 8
        x: calcPos()
        y: expInput.cursorRectangle.y + expInput.cursorRectangle.height + expInput.y

        onItemChoosed: {
            var end = expInput.cursorPosition
            var start = end - currentText.length

            expInput.remove(start, end)
            expandExpression(currentItem["identifier"])
        }

        function calcPos() {
            if(expInput.cursorRectangle.x + completer.width + fmExpInput.advanceWidth(" ") < expInput.width)
                return expInput.cursorRectangle.x + expInput.x
            else
                return expInput.x + expInput.width - completer.width - expInput.textMargin
        }
    }

    function currentWord() {
        var result = ""
        var startIndex = expInput.cursorPosition - 1
        var regExp = new RegExp(Calculator.expressionSplittersRegExp)

        if(expInput.cursorPosition == 0)
            return

        while(expInput.text[startIndex]) {
            if(expInput.text[startIndex].match(regExp))
                break;
            --startIndex
        }
        startIndex++;

        while(expInput.text[startIndex]) {
            if(expInput.text[startIndex].match(regExp))
                break
            result += expInput.text[startIndex]
            startIndex++
        }

        return result
    }

    function completeText() {
        var lastChar = expInput.text.slice(-1)
        if(Calculator.expressionSplitters.indexOf(lastChar) != -1)
            completer.show()

        if(typeof currentWord() != "undefined")
            completer.currentText = currentWord()
        else
            completer.currentText = ""

        completer.currentTextChanged(completer.currentText)
    }

    function overwriteExpression(newExpression) {
        expInput.text = newExpression
    }

    function expandExpression(expansionKey) {
        var expansionData = Calculator.expressionsExpansion[expansionKey]
        var selectedStart = expInput.selectionStart
        var selectedText = expInput.selectedText
        var selectedEnd = expInput.selectionEnd
        var expansion, expansionType

        // if not found, then it is not in Settings, so use normal expansion
        expansion = (typeof expansionData === "undefined") ?expansionKey :expansionData["expansion"]
        expansionType = (typeof expansionData === "undefined") ?Expansion.Normal :expansionData["expansionType"]

        expInput.remove(selectedStart, selectedEnd)

        if(expansionType == Expansion.BracketsPack)
            expInput.insert(selectedStart, expansion + selectedText + ")")

        else
            expInput.insert(selectedStart, expansion)
    }

    function handleResult(data) {
        if(typeof data["result"] !== "undefined") {
            resultDisplay.result = data["result"]
            resultSystemDisplay.value = data["unformattedResult"]
        }
        else
            expInput.text = ""

        var variablesDiff = data["variablesDiff"]["new"].concat(data["variablesDiff"]["modified"])
        var variables = data["variables"]

        for(var key in variablesDiff) {
            var identifier = variablesDiff[key]
            variablePanel.handleVariableAction(identifier, variables[identifier].expression, variables[identifier].value)
        }
    }
}
