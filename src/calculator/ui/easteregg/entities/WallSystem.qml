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
