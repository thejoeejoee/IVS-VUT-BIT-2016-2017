import QtQuick 2.0
import "../controls" as Control

/**
  Panel of function buttons
  */
Item {
    id: component

    /// Emits after clicking on function button, so function identifier could be expanded
    signal expandRequest(string func)

    /// List of functions to be delegated
    property var items
    /// Number of columns in which will be button displayed
    property alias columns: grid.columns
    /// Background color of buttons
    property color backgroundColor
    /// Text color of labels on buttons
    property color textColor
    /// Background color of mask when button is hovered
    property color hoverColor

    Grid {
        id: grid

        rows: Math.ceil(component.items.length / columns)

        Repeater{
            model: component.items
            delegate: Control.TextButton{
                buttonText: modelData
                textColor: component.textColor
                color: component.backgroundColor
                hoverColor: component.hoverColor

                width: component.width / grid.columns
                height: component.height / grid.rows

                onClicked: component.expandRequest(modelData)
            }
        }
    }
}

