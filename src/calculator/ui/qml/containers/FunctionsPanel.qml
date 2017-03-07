import QtQuick 2.0
import "../controls" as Control

Item {
    id: component

    signal clicked(string func)

    property var items
    property alias columns: grid.columns

    Grid {
        id: grid

        rows: Math.ceil(component.items.length / columns)

        Repeater{
            model: component.items
            delegate: Control.TextButton{
                buttonText: modelData
                textColor: "white"
                color: "grey"
                hoverTextColor: "red"

                width: component.width / grid.columns
                height: component.height / grid.rows

                onClicked: component.clicked(modelData)
            }
        }
    }
}

