import QtQuick 2.5
import QtQuick.Window 2.0
import QtQuick.Controls 1.4
import Sides 1.0

import "entities" as Entities
import "visualization" as Visualization
import "logic/collision" as Collision

ApplicationWindow {
    id: gameWindow

    signal run()
    signal gameOver(string msg)

    property bool running: false
    property int playerScore: 0
    property int enemyScore: 0
    property int maxScore: 3
    property size playerSize: Qt.size(10, 100)

    width: 1500
    height: 800

    visible: true
    modality: Qt.ApplicationModal
    //visibility: Window.FullScreen

    onRun: {
        visible = true
        startGame()
    }

    onGameOver: endGame()

    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    Visualization.Score {
        playerScore: gameWindow.playerScore
        enemyScore: gameWindow.enemyScore

        textColor: "lightGray"

        anchors.fill: parent
    }

    Collision.CollisionSystem {
        id: collisionSystem
    }

    Entities.WallSystem {
        wallWidth: 18
        wallColor: "#2D2D2D"
        collisionSystem: collisionSystem

        anchors.fill: parent

        Component.onCompleted: registerObject(nyan)
    }

    Timer {
        id: frameTimer

        interval: 5
        running: true
        repeat: true

        onTriggered: {
            nyan.frameMove()
            player.frameMove()
            ai.frameMove()
        }
    }

    // ----- BALL -----
    Entities.NyanCat {
        id: nyan

        width: 50
        height: width

        rootItem: gameWindow.contentItem
        onCollidedWithWall: handleCollisionWithWall(obj, side)
    }

    // ----- PLAYERS -----
    Entities.Player {
        id: player

        step: 2.5
        width: playerSize.width
        height: playerSize.height

        Component.onCompleted: collisionSystem.registerPair(player, nyan)
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: player.wantedPosition = mouse.y
    }

    Entities.Player {
        id: ai

        step: 5
        wantedPosition: nyan.y + nyan.height / 2
        width: playerSize.width
        height: playerSize.height

        anchors.right: parent.right

        Component.onCompleted: collisionSystem.registerPair(ai, nyan)
    }

    function startGame() {
        nyan.vector = Qt.point(Math.cos(Math.PI / 3), -Math.sin(Math.PI / 3))
        nyan.x = gameWindow.width / 2 - nyan.width / 2
        nyan.y = gameWindow.height / 2 - nyan.height / 2
        gameWindow.playerScore = 0
        gameWindow.enemyScore = 0
        gameWindow.visible = true
        frameTimer.running = true
    }

    function endGame() {
        frameTimer.running = false
        gameWindow.visible = false
    }

    function handleCollisionWithWall(obj, side) {
        if(!obj.isVoid)
            return

        if(side == Sides.Right)
            gameWindow.playerScore += 1
        else
            gameWindow.enemyScore += 1

        if(gameWindow.enemyScore == gameWindow.maxScore)
            gameWindow.gameOver("YouAreLooser")
        if(gameWindow.playerScore == gameWindow.maxScore)
            gameWindow.gameOver("AIIsNoob")
    }
}
