import QtQuick 2.0

/**
  Base type for Entity
  */
Rectangle {
    id: component

    /**
      Emits after collision with other BoxCollider
      @param obj Object with which current item collided
      @param side Side of collision relative to current item
      */
    signal collided(var obj, int side)

    /// Defines whether is BoxCollider as void border
    property bool isVoid: false
}
