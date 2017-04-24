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
import "../logic/extendedmath.js" as EMath
import "../logic/collision" as Collision

/**
  This entitiy is used as player(rebound area)
  */
Collision.BoxCollider {
    id: component

    /// Position to which player will move
    property real wantedPosition: 0
    /// Step of movement in pixels per frame
    property real step

    color: "orange"

    /**
      Set Player new position, need to be called every frame
      */
    function frameMove() {
        var posDifference = wantedPosition - component.y - component.height / 2

        if(Math.abs(posDifference) > component.step)
            component.y += EMath.sgn(posDifference) * component.step
        else
            component.y = wantedPosition - component.height / 2
    }
}
