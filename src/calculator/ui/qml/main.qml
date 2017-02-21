import QtQuick 2.7
import QtQuick.Controls 1.4
import "window" as Window
import Sides 1.0

import "../easteregg"

Window.CustomWindow {
    id: mainWindow

    width: 1500
    height: 800
    flags: Qt.FramelessWindowHint
    visible: true

    Item{
        Game {
            id: game

            Component.onCompleted: game.run()
            onGameOver: console.log(msg)
        }
    }
}
