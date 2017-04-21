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
import QtQuick 2.0
import Sides 1.0
import "../logic/collision"

/**
  System of walls to border all playground edges
  */
Item {
    id: component

    /**
      Emits collision with some wall in system
      @param side Side of collision related to wall
      */
    signal voidCollided(int side)

    /// Reference to global CollisionSystem to determinate collision
    property CollisionSystem collisionSystem
    /// Width of walls in pixels
    property real wallWidth: 10
    /// Color of walls
    property color wallColor

    Wall {
        id: topWall

        height: component.wallWidth
        color: component.wallColor

        anchors.left: parent.left
        anchors.right: parent.right
    }

    Wall {
        id: bottomWall

        height: component.wallWidth
        color: component.wallColor

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }

    Wall {
        id: leftVoid

        isVoid: true
        width: component.wallWidth

        anchors.right: parent.left
        anchors.top: topWall.top
        anchors.bottom: bottomWall.bottom

        onCollided: component.voidCollided(side)
    }

    Wall {
        id: rightVoid

        isVoid: true
        width: component.wallWidth

        anchors.left: parent.right
        anchors.top: topWall.top
        anchors.bottom: bottomWall.bottom

        onCollided: component.voidCollided(side)
    }

    function registerObject(obj) {
        component.collisionSystem.registerPair(obj, topWall)
        component.collisionSystem.registerPair(obj, bottomWall)
        component.collisionSystem.registerPair(obj, leftVoid)
        component.collisionSystem.registerPair(obj, rightVoid)
    }
}
