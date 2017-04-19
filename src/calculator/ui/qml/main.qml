import QtQuick 2.7
import QtQuick.Controls 1.4

import ExpSyntaxHighlighter 1.0
import ExpAnalyzer 1.0
import Sides 1.0
import Calculator 1.0
import Expansion 1.0
import Expression 1.0
import StyleSettings 1.0
import AppWindow 1.0

import "controls" as Control
import "menu"
import "../easteregg"
import "loaders" as Loaders
import "windows" as Windows

import "containers"
import "visualization"

AppWindow {
    id: mainWindow

    width: 1101
    ratio: 522/1101.
    height: 522

    title: qsTr("Calculator")
    visible: true

    Item {
        id: root
        anchors.fill: parent
    }

    AppMenuBar {
        color: StyleSettings.appMenuBar.color
        font: StyleSettings.appMenuBar.font

        title: qsTr("Help")
        titleColor: StyleSettings.appMenuBar.title.color
        titleActiveColor: StyleSettings.appMenuBar.title.activeColor

        items: [qsTr("Help"), qsTr("About")]

        itemBackgroundColor: StyleSettings.appMenuBar.item.backgroundColor
        itemBorderColor: StyleSettings.appMenuBar.item.borderColor
        itemHoverColor: StyleSettings.appMenuBar.item.hoverColor
        itemTextColor: StyleSettings.appMenuBar.item.textColor
        itemHoverTextColor: StyleSettings.appMenuBar.item.hoverTextColor

        z: 3
        width: 200
        height: 24
        menuWidth: 100
        menuItemHeight: 19

        onItemChoosed: {
            if(item == qsTr("About"))
                aboutWindow.show()
            if(item == qsTr("Help"))
                helpWindow.show()
        }
    }

    Game {
        id: game

        onGameOver: info.show(msg)
    }

    ExpAnalyzer {
        id: exa
        target: expInput
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
        scrollBarColor: StyleSettings.variablesPanel.scrollBarColor

        ansTextColor: StyleSettings.ans.textColor
        ansIdentifierTextColor: StyleSettings.ans.identifierColor
        ansColor: StyleSettings.ans.backgroundColor
        ansExpressionHoverColor: StyleSettings.ans.expressionHoverColor
        ansScrollbarColor: StyleSettings.ans.scrollbarColor
        ansPrompterTheme: StyleSettings.ans.prompterTheme
        ansHoverColor: StyleSettings.ans.hoverColor

        dotsBackgroundColor: StyleSettings.variableItem.dots.color
        removeButtonColor: StyleSettings.variableItem.removeButton.color
        settersColor: StyleSettings.variableItem.setters.color
        settersHoveredColor: StyleSettings.variableItem.setters.hoverColor
        settersTextColor: StyleSettings.variableItem.setters.textColor
        itemScrollbarColor: StyleSettings.variableItem.scrollbarColor
        textColor: StyleSettings.variableItem.textColor
        identifierTextColor: StyleSettings.variableItem.identifierColor
        expressionHoverColor: StyleSettings.variableItem.expressionHoverColor
        prompterTheme: StyleSettings.variableItem.prompterTheme
        hoverColor: StyleSettings.variableItem.hoverColor

        font.family: StyleSettings.variablesPanel.font.family

        width: parent.width / 3.2
        height: parent.height
        itemHeight: parent.height / 6

        anchors.top: parent.top
        anchors.right: parent.right

        onDeleteVariableRequest: {
            if(Calculator.removeVariable(identifier))
               variablePanel.deleteVariable(identifier)
        }
        onSetVariableRequest: Calculator.setVariableValue(identifier, value)
        onExpandRequest: forceExpandExpression(data)
        onOverwriteRequest: overwriteExpression(data)
    }

    FunctionsPanel {
        id: functionPanel

        items: Calculator.builtinFunctions
        columns: 1
        backgroundColor: StyleSettings.functionPanel.backgroundColor
        textColor: StyleSettings.functionPanel.textColor
        hoverColor: StyleSettings.functionPanel.hoverColor

        height: parent.height * 0.45
        width: parent.width / 15.7

        anchors.left: parent.left
        anchors.bottom: parent.bottom

        onExpandRequest: expandExpressionAroundWord(func)
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
            if(text.search("nyan") != -1)
                countDown.start(3)

            completeText()
            showFunctionSignature()
        }
        onSelectedTextChanged: {
            if(selectedText.length) {
                completer.model = completer.constantModel
                completer.currentText = ""
            }
            else {
                completeText()
                showFunctionSignature()
            }
        }
        onCursorPositionChanged: {
            completeText()
            showFunctionSignature()
        }

        Keys.onPressed: {
            if(expInput.selectedText != "" && event.text == "(") {
                expInput.insert(expInput.selectionEnd, ")")
                expInput.cursorPosition = expInput.selectionStart
                expInput.deselect()
            }
        }
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
        basesList: ["BIN", "OCT", "DEC", "HEX"]
        bases: { "DEC": 10, "BIN": 2, "HEX": 16, "OCT": 8 }
        height: parent.height / 5.1
        scrollbarColor: StyleSettings.resultSystemDisplay.scrollbarColor
        baseTextColor: StyleSettings.resultSystemDisplay.baseTextColor
        valueTextColor: StyleSettings.resultSystemDisplay.valueTextColor
        prompterTheme: StyleSettings.resultSystemDisplay.prompterTheme
        font: StyleSettings.resultSystemDisplay.font

        anchors.bottom: functionPanel.top
        anchors.left: parent.left
        anchors.right: variablePanel.left
        anchors.rightMargin: height / 20
    }

    Control.CalculateButton {
        id: calculateButton

        width: parent.width / 14

        color: StyleSettings.calculateButton.backgroundColor
        hoverColor: StyleSettings.calculateButton.hoverColor

        anchors.top: expInput.top
        anchors.bottom: parent.bottom
        anchors.right: variablePanel.left

        onClicked: Calculator.process(expInput.text)
    }

    PopUp {
        id: error

        title: qsTr("Error")
        maskColor: StyleSettings.errorDialog.maskColor
        dialogColor: StyleSettings.errorDialog.color
        textColor: StyleSettings.errorDialog.textColor
        font: StyleSettings.errorDialog.font
        z: 2

        anchors.fill: parent

        onHidden: expInput.focus = true
    }

    PopUp {
        id: info

        title: qsTr("Info")
        maskColor: StyleSettings.infoDialog.maskColor
        dialogColor: StyleSettings.infoDialog.color
        textColor: StyleSettings.infoDialog.textColor
        font: StyleSettings.infoDialog.font
        z: 2

        anchors.fill: parent

        onHidden: expInput.focus = true
    }

    CountDown {
        id: countDown

        anchors.fill: parent
        font.family: StyleSettings.countDown.font
        color: StyleSettings.countDown.textColors[count + 1]


        onTriggered: {
            expInput.focus = true
            expInput.text = ""
            game.run()
        }
    }

    Component.onCompleted: {
        Calculator.processed.connect(handleResult)
        Calculator.error.connect(error.show)
    }

    FunctionSignatureDisplay {
        id: functionSignature

        color: StyleSettings.functionSignatureDisplay.color
        textColor: StyleSettings.functionSignatureDisplay.textColor
        font: StyleSettings.functionSignatureDisplay.font
        constantOpacity: 0.8

        x: completer.calcTextInfoPos(width)
        y: expInput.cursorRectangle.y - height + expInput.y
        height: completer.itemHeight * 1.2
    }

    Control.Completer {
        id: completer

        target: expInput
        constantModel: Calculator.identifiersTypes

        opacity: 0.8
        color: StyleSettings.completer.color
        hoverColor: StyleSettings.completer.hoverColor
        textColor: StyleSettings.completer.textColor
        scrollBarColor: StyleSettings.completer.scrollBarColor

        width: parent.width * 0.18
        itemHeight: width / 8
        x: calcTextInfoPos(width)
        y: expInput.cursorRectangle.y + expInput.cursorRectangle.height + expInput.y

        onItemChoosed: {
            expandExpression(currentItem["identifier"])
        }

        function calcTextInfoPos(infoWidth) {
            if(expInput.cursorRectangle.x + infoWidth + fmExpInput.advanceWidth(" ") < expInput.width)
                return expInput.cursorRectangle.x + expInput.x
            else
                return expInput.x + expInput.width - infoWidth - expInput.textMargin
        }

    }

    Windows.About {
        id: aboutWindow

        revision: "3eecc99"
        color: StyleSettings.aboutWindow.color
        textColor: StyleSettings.aboutWindow.textColor
        titleColor: StyleSettings.aboutWindow.titleColor
        font: StyleSettings.aboutWindow.font

        z: 3
        width: mainWindow.width
        height: mainWindow.height

        onHidden: expInput.focus = true
    }

    Windows.Help {
        id: helpWindow

        textColor: StyleSettings.helpWindow.textColor
        titleColor: StyleSettings.helpWindow.titleColor
        subtitleColor: StyleSettings.helpWindow.subtitleColor
        scrollBarColor: StyleSettings.helpWindow.scrollBarColor
        textFont.family: StyleSettings.helpWindow.font.family

        width: 400
        height: 600
    }

    /**
      Show suggestion box with filtered suggestions
      */
    function completeText() {
        var lastChar = expInput.text.slice(-1)
        var currentWord = exa.currentWord()

        if(expInput.cursorPosition)
            lastChar = expInput.text[expInput.cursorPosition - 1]

        if(Calculator.expressionSplitters.indexOf(lastChar) != -1)
            completer.show()

        completer.currentText = currentWord
        completer.currentTextChanged(completer.currentText)
    }

    function showFunctionSignature() {
        var funcSignature = exa.currentFunctionSignature()

        functionSignature.show(funcSignature)
    }

    /**
      Overwrite current expression by new expression
      @param newExpression New expression
      */
    function overwriteExpression(newExpression) {
        expInput.text = newExpression
        expInput.cursorPosition = expInput.text.length
    }

    /**
      Expand expression into current expresion without any optimatizations
      @param expression Inserting expansion
      */
    function forceExpandExpression(expansion) {
        expInput.insert(expInput.selectionStart, expansion)
    }

    /**
      Expand expression into current expresion around currend word if there isn't and text selected
      @param expression Key of builtin expression or dynamic expression
      */
    function expandExpressionAroundWord(expansion) {
        expansion = exa.expandExpression(expansion, true)
        var borders = exa.currentWordBorders()

        if(expInput.selectedText == "")
            expInput.remove(borders["start"], borders["end"])
        else
            expInput.remove(expInput.selectionStart, expInput.selectionEnd)

        expInput.insert(expInput.selectionStart, expansion)
    }

    /**
      Expand expression into current expresion
      @param expression Key of builtin expression or dynamic expression
      */
    function expandExpression(expansion) {
        var moveCursorInsideFunction = false
        var expansionType = exa.expansionType(expansion)
        expansion = exa.expandExpression(expansion, false)

        if(expInput.selectedText == "") {
            var borders = exa.currentWordBorders()
            expInput.remove(borders["start"], borders["end"])
            moveCursorInsideFunction = true
        }

        else
            expInput.remove(expInput.selectionStart, expInput.selectionEnd)

        expInput.insert(expInput.selectionStart, expansion)

        // if only expand empty function put cursor inside its body
        // need to move to get know function signature
        if(moveCursorInsideFunction && expansionType == Expansion.BracketsPack)
            expInput.cursorPosition--;

        // but if function does not take any paramaters put cursor on the end
        // if contains "()" in signature => it's function that does not take any parameter
        if(exa.currentFunctionSignature().indexOf("()") != -1)
            expInput.cursorPosition++;
    }

    /**
      After calculation handles variable and display synchronization
      @param data Data with result and variables
      */
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
