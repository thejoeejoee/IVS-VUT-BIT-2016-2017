import QtQuick 2.0
import Sides 1.0
import QtQuick.Particles 2.0
import "../logic/collision" as Collision
import "../animations" as Animations
import "../logic/extendedmath.js" as EMath

Collision.BoxCollider {
    id: nyanCat

    property alias vector: data.vector
    property real angle: 0

    border.color: "orange"
    border.width: 1
    color: "transparent"

    onCollided: handleCollision(obj, side)
    Component.onCompleted: rotateNyanCat()

    QtObject {
        id: data

        property int previousCollisionSide: -1
        property point vector: Qt.point(Math.cos(Math.PI / 3), -Math.sin(Math.PI / 3))
    }

    Animations.RainbowTail {
        id: tail

        width: height / 6
        height: nyanCat.height

        generationAngle: rotation + ((data.vector.x < 0) ?0 :180)
        rotation: nyanCat.angle
        particleSize: Qt.size(10, 10)

        containerItem: nyanCat
        rootItem: root

        anchors.centerIn: parent
    }

    function rotateNyanCat() {
        var v = Qt.point(data.vector.x, data.vector.y)

        nyanCat.angle = (v.x === 0) ?90 :(Math.atan(v.y / v.x) / Math.PI * 180)
    }

    function handleCollision(obj, collisionSide) {
        // if object if in another object, then handle collision only once
        if(data.previousCollisionSide == collisionSide)
            return
        data.previousCollisionSide = collisionSide

        var newVector = Qt.point(data.vector.y, data.vector.x)

        // determine unchanging direction to modify vector
        if(collisionSide == Sides.Right || collisionSide == Sides.Left){
            newVector.x = Math.abs(newVector.x) * (-EMath.sgn(vector.x))
            newVector.y = Math.abs(newVector.y) * EMath.sgn(vector.y)
        }

        if(collisionSide == Sides.Bottom || collisionSide == Sides.Top) {
            newVector.y = Math.abs(newVector.y) * (-EMath.sgn(data.vector.y))
            newVector.x = Math.abs(newVector.x) * EMath.sgn(data.vector.x)
        }

        data.vector = newVector
        rotateNyanCat()
    }
}
