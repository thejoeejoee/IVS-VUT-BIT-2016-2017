import QtQuick 2.0
import "../controls" as Control

Item {
    id: funcPanel
    property variant items: ["root()","cos()","sin()","pow()","pi","e","log()","abs()"]
    Grid{
        height: funcPanel.height/8
        width: 50
        columns: 1
        rows: 8
        spacing: 0
        Repeater{
            model: 8
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
