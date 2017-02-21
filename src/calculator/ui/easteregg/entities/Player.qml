import QtQuick 2.0
import "../logic/extendedmath.js" as EMath
import "../logic/collision" as Collision

Collision.BoxCollider {
    id: component

    property real wantedPosition: 0
    property real step

    color: "orange"

    function frameMove() {
        var posDifference = wantedPosition - component.y - component.height / 2

        if(Math.abs(posDifference) > component.step)
            component.y += EMath.sgn(posDifference) * component.step
        else
            component.y = wantedPosition - component.height / 2
    }
}
