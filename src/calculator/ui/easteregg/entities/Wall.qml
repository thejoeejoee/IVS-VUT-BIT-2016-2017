import QtQuick 2.0
import QtQuick.Controls 2.0
import Sides 1.0
import "../logic/collision" as Collision

/**
  This entity works as rebound area, but is static
  */
Collision.BoxCollider {
    id: component

    color: "transparent"
}
