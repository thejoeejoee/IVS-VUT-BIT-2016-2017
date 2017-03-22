import QtQuick 2.0

/**
  Container item with addition and move animation
  */
Column {
    id: component

    add: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 200 }
    }

    move: Transition {
        NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.InOutQuad }
    }
}
