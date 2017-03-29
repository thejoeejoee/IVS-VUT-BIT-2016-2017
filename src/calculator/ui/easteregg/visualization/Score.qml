import QtQuick 2.0

/**
  Display score in format X:Y
  */
Item {
    id: component

    /// Score of player
    property int playerScore: 0
    /// Score of other player
    property int enemyScore: 0
    /// Color of score text
    property alias textColor: text.color

    Text {
        id: text

        text: component.playerScore + "-" + component.enemyScore

        font.family: "Roboto Light"
        font.pixelSize: component.height / 2

        anchors.centerIn: parent
    }
}
