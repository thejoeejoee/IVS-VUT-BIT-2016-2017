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
import "../extendedmath.js" as EMath

/**
  System to determinate collision of registered objects
  */
QtObject {
    id: system

    /**
      Checks whether collision between two objects happened
      @param bc1 First object
      @param bc2 Second object
      @return Side of collision referenced to first object, if collision did not happened return -1
      */
    function checkCollision(bc1, bc2) {
        var r1 = bc1.mapToItem(null, 0, 0, bc1.width, bc1.height)
        var r2 = bc2.mapToItem(null, 0, 0, bc2.width, bc2.height)

        // need reference box collider to determinate side collision
        var referenceBc = r1
        var otherBc = r2

        var overlap = Qt.point(0, 0)
        overlap.x = Math.min(r1.x + r1.width, r2.x + r2.width) - Math.max(r1.x, r2.x);
        overlap.y = Math.min(r1.y + r1.height, r2.y + r2.height) - Math.max(r1.y, r2.y);

        // check if there is overlap, if both are positive, then there is overlap
        if(overlap.x < 0 || overlap.y < 0)
            return -1

        // vertical collision
        if(Math.min(overlap.x, overlap.y) == overlap.y) {
            if(otherBc.y < referenceBc.y)
                return Sides.Top
            return Sides.Bottom
        }

        // horizontal collision
        if(otherBc.x < referenceBc.x)
            return Sides.Left
        return Sides.Right
    }

    /**
      Checks for collisions and if collision occure then emits signals of objects
      @param bc1 First object
      @param bc2 Second object
      */
    function watchCollision(bc1, bc2) {
        var result = system.checkCollision(bc1, bc2)

        if(result != -1) {
            bc1.collided(bc2, result)
            bc2.collided(bc1, Sides.oppositeSide(result))
        }
    }

    /**
      Register objects to system
      @param bc1 First object
      @param bc2 Second object
      */
    function registerPair(bc1, bc2) {
        bc1.xChanged.connect((function() {system.watchCollision(bc1, bc2)}))
        bc1.yChanged.connect((function() {system.watchCollision(bc1, bc2)}))

        bc2.xChanged.connect((function() {system.watchCollision(bc1, bc2)}))
        bc2.yChanged.connect((function() {system.watchCollision(bc1, bc2)}))
    }
}
