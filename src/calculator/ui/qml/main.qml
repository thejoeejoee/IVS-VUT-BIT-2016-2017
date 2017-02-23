import QtQuick 2.7
import QtQuick.Controls 1.4
import ExpSyntaxHighlighter 1.0
import "window" as Window
import Sides 1.0

import "../easteregg"
import "loaders" as Loaders

// TODO delete
import "containers"
import "visualization"

Window.CustomWindow {
    id: mainWindow

    width: 1101
    height: width * (522 / 1101)

    flags: Qt.FramelessWindowHint
    visible: true

    Item{
        Game {
            id: game

            Component.onCompleted: game.run()
            onGameOver: console.log(msg)
        }
    }

    Item {
        ExpSyntaxHighlighter {
            id: esh
            target: te
        }
    }

    TextEdit {
        id: te
        width: 100
        height: 100
        color: "blue"
    }

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
}
