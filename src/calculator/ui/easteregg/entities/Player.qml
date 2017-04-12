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
