/**************************************************************************
**   Calculator
**   Copyright (C) 2017 /dej/uran/dom team
**   Authors: Son Hai Nguyen
**   Credits: Josef Kolář, Son Hai Nguyen, Martin Omacht, Robert Navrátil
**
**   This program is free software: you can redistribute it and/or modify
**   it under the terms of the GNU General Public License as published by
**   the Free Software Foundation, either version 3 of the License, or
**   (at your option) any later version.
**
**   This program is distributed in the hope that it will be useful,
**   but WITHOUT ANY WARRANTY; without even the implied warranty of
**   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**   GNU General Public License for more details.
**
**   You should have received a copy of the GNU General Public License
**   along with this program.  If not, see <http://www.gnu.org/licenses/>.
**************************************************************************/
import QtQuick 2.5
import QtQuick.Window 2.0
import QtQuick.Controls 1.4
import Sides 1.0

import "entities" as Entities
import "visualization" as Visualization
import "logic/collision" as Collision

/**
  Standalone window with game(pong)
  */
ApplicationWindow {
    id: gameWindow

    /**
      Used as function to start game
      */
    signal run()
    /**
      Emits when some of players loose
      @param msg Message to player
      */
    signal gameOver(string msg)

    /// Score of player
    property int playerScore: 0
    /// Score of other player
    property int enemyScore: 0
    /// Max score which player need to archieve to win
    readonly property int maxScore: 2
    /// Size of player rebound area
    property size playerSize: Qt.size(10, 100)

    width: 1500
    height: 800

    title: qsTr("Easter egg")
    visible: false
    modality: Qt.ApplicationModal

    onRun: {
        visibility = Window.FullScreen
        visible = true
        startGame()
    }

    onClosing: endGame()
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
        running: false
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

        x: gameWindow.width / 2 - nyan.width / 2
        y: gameWindow.height / 2 - nyan.height / 2
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

        Component.onCompleted: collisionSystem.registerPair(nyan, player)
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

        Component.onCompleted: collisionSystem.registerPair(nyan, ai)
    }

    /**
      Resets component to begin game
      */
    function startGame() {
        nyan.vector = Qt.point(Math.cos(Math.PI / 3), -Math.sin(Math.PI / 3))
        nyan.rotateNyanCat()
        nyan.x = gameWindow.width / 2 - nyan.width / 2
        nyan.y = gameWindow.height / 2 - nyan.height / 2
        gameWindow.playerScore = 0
        gameWindow.enemyScore = 0
        gameWindow.visible = true
        frameTimer.running = true
    }

    /**
      Sets component to end game
      */
    function endGame() {
        frameTimer.running = false
        gameWindow.visible = false
    }

    /**
      React to collision of ball to increment score
      @param obj Ball reference
      @param side Side of collision to determinate who has point
      */
    function handleCollisionWithWall(obj, side) {
        if(!obj.isVoid)
            return

        if(side == Sides.Right)
            gameWindow.playerScore += 1
        else
            gameWindow.enemyScore += 1

        if(gameWindow.enemyScore == gameWindow.maxScore)
            gameWindow.gameOver(qsTr("You are looser."))
        if(gameWindow.playerScore == gameWindow.maxScore)
            gameWindow.gameOver(qsTr("AI is noob."))
    }
}
