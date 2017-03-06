import QtQuick 2.0
import "../controls" as Control

Item {
    id: funcPanel
    property variant items: ["root()","cos()","sin()","pow()","pi","e","log()","abs()"]
    Grid{
        height: funcPanel.height/7
        width: parent.width
        columns: 1
        rows: 7
        spacing: 0
        Repeater{
            model: 7
            Control.TextButton{
                buttonText: funcPanel.items[index]
                textColor: "red"
                color: "grey"
                hoverColor: "red"
                hoverTextColor: "black"
            }
        }
    }
}
