import QtQuick 2.0
import Sides 1.0
import "../extendedmath.js" as EMath

QtObject {
    id: system

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

    function watchCollision(bc1, bc2) {
        var result = system.checkCollision(bc1, bc2)

        if(result != -1) {
            bc1.collided(bc2, result)
            bc2.collided(bc1, Sides.oppositeSide(result))
        }
    }

    function registerPair(bc1, bc2) {
        bc1.xChanged.connect((function() {system.watchCollision(bc1, bc2)}))
        bc1.yChanged.connect((function() {system.watchCollision(bc1, bc2)}))

        bc2.xChanged.connect((function() {system.watchCollision(bc1, bc2)}))
        bc2.yChanged.connect((function() {system.watchCollision(bc1, bc2)}))
    }
}
