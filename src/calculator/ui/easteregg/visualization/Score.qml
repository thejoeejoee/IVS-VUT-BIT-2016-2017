import QtQuick 2.0

Item {
    id: component

    property int playerScore: 0
    property int enemyScore: 0
    property alias textColor: text.color

    Text {
        id: text

        text: component.playerScore + "-" + component.enemyScore

        font.family: "Roboto Light"
        font.pixelSize: component.height / 2

        anchors.centerIn: parent
    }
}
