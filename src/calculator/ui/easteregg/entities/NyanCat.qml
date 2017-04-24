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
import QtQuick.Particles 2.0
import "../logic/collision" as Collision
import "../animations" as Animations
import "../logic/extendedmath.js" as EMath

/**
  Ball entity used in easter egg pong game
  */
Collision.BoxCollider {
    id: nyanCat

    /**
      Emits collision with wall
      @param obj Object which collided with NyanCat
      @param collisionSide Side of collision relative to NyanCat
      */
    signal collidedWithWall(var obj, int side)

    /// Expose vector
    property alias vector: internal.vector
    /// Expose root item to bring nyan image forward
    property alias rootItem: tail.rootItem
    /// Angle of NyanCat
    property real angle: 0

    color: "transparent"

    onCollided: handleCollision(obj, side)
    Component.onCompleted: rotateNyanCat()

    QtObject {
        id: internal

        /// Object which previously collided with NyanCat
        property var previousCollisionObj: null
        /// Defines direction and velocity of nyan cat
        property point vector: Qt.point(Math.cos(Math.PI / 3), -Math.sin(Math.PI / 3))
    }

    Animations.RainbowTail {
        id: tail

        width: height / 6
        height: nyanCat.height

        generationAngle: rotation + ((internal.vector.x < 0) ?0 :180)
        rotation: nyanCat.angle
        particleSize: Qt.size(10, 10)

        containerItem: nyanCat
        rootItem: root

        anchors.centerIn: parent
    }

    Image {
        z: 4
        parent: rootItem
        fillMode: Image.PreserveAspectFit
        source: "qrc:/assets/images/nyan.svg"

        rotation: nyanCat.angle
        height: nyanCat.height * 1.2
        mirror: (nyanCat.vector.x < 0)

        anchors.centerIn: nyanCat

        sourceSize.width: 700
        sourceSize.height: 700
    }

    /**
      Step move of NyanCat
      */
    function frameMove() {
        var step = 7

        nyanCat.x += nyanCat.vector.x * step
        nyanCat.y += nyanCat.vector.y * step
    }

    /**
      Calculate and set rotation of NyanCat
      */
    function rotateNyanCat() {
        var v = Qt.point(internal.vector.x, internal.vector.y)

        nyanCat.angle = (v.x === 0) ?90 :(Math.atan(v.y / v.x) / Math.PI * 180)
    }

    /**
      Set new vector of NyanCat and emit collision
      @param obj Object which collided with NyanCat
      @param collisionSide Side of collision relative to NyanCat
      */
    function handleCollision(obj, collisionSide) {
        // if object if in another object, then handle collision only once
        if(internal.previousCollisionObj == obj)
            return
        nyanCat.collidedWithWall(obj, collisionSide)
        internal.previousCollisionObj = obj

        var newVector = Qt.point(internal.vector.y, internal.vector.x)

        // determine unchanging direction to modify vector
        if(collisionSide == Sides.Right || collisionSide == Sides.Left){
            newVector.x = Math.abs(newVector.x) * (-EMath.sgn(vector.x))
            newVector.y = Math.abs(newVector.y) * EMath.sgn(vector.y)
        }

        if(collisionSide == Sides.Bottom || collisionSide == Sides.Top) {
            newVector.y = Math.abs(newVector.y) * (-EMath.sgn(internal.vector.y))
            newVector.x = Math.abs(newVector.x) * EMath.sgn(internal.vector.x)
        }

        internal.vector = newVector
        rotateNyanCat()
    }
}
