import QtQuick 2.0

Rectangle {
    id: component

    signal collided(var obj, int side)

    property bool isVoid: false
}
