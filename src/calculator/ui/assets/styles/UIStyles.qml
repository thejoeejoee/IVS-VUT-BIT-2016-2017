pragma Singleton
import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
// TODO allow
import Expression 1.0

QtObject {
    id: styles

    property QtObject functionPanel: QtObject {
        property color backgroundColor: "#2A2A2A"
        property color textColor: "white"
        property color hoverTextColor: "#ED1D3D"
    }

    property QtObject expressionInput: QtObject {
        id: expressionInputStyle

        property int _scrobarWidth: 8
        property color placeholderTextColor: "#9F9F9F"
        property Component style: TextAreaStyle {
            backgroundColor: "#F2F2F2"
            textColor: "#9F9F9F"
            selectionColor: "#FFE1EB"
            selectedTextColor: textColor

            handle: Rectangle {
                x: (expressionInputStyle._scrobarWidth - implicitWidth) / 2
                color: "#ED1D3D"
                implicitWidth: 4
                radius: implicitWidth / 2
            }

            scrollBarBackground: Rectangle {
                implicitWidth: expressionInputStyle._scrobarWidth
                color: "transparent"
            }

            decrementControl: Image {
                source: "qrc:/assets/images/arrow_down.svg"
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(parent.width, parent.height)
                rotation: 180

                width: expressionInputStyle._scrobarWidth
                height: width
            }

            incrementControl: Image {
                source: "qrc:/assets/images/arrow_down.svg"
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(parent.width, parent.height)

                width: expressionInputStyle._scrobarWidth
                height: width
            }
        }

        property font font: Qt.font({
            family: "ABeeZee"
        })
    }

    property QtObject variablesPanel: QtObject {
        property color backgroundColor: "#2A2A2A"
        property color textColor: "white"
        property color identifierColor: "#ED1946"
        property color expressionHoverColor: "#3D3D3D"
        property color scrollBarColor: "#B7B7B7"
        property font font: Qt.font({
            family: "Roboto Light"
        })
    }

    property QtObject ans: QtObject {
        property color backgroundColor: "#C1C0C0"
        property color textColor: "white"
        property color identifierColor: "black"
        property color expressionHoverColor: "#AAAAAA"
        property color scrollbarColor: "black"
        property font font: styles.variablesPanel.font
    }

    property QtObject variableItem: QtObject {
        property color scrollbarColor: "#ED1D3D"
        property QtObject dots: QtObject {
            property color color: "#3D3D3D"
        }

        property QtObject removeButton: QtObject {
            property color color: "#D71F26"
        }

        property QtObject setters: QtObject {
            property color color: "#2C2C2C"
            property color hoverColor: "#3D3D3D"
            property color textColor: "white"
        }
    }

    property QtObject resultDisplay: QtObject {
        property color backgroundColor: "white"
        property color textColor: "#2F2F2F"
        property font font: Qt.font({
            family: "Roboto Medium"
        })
    }

    property QtObject calculateButton: QtObject {
        property color backgroundColor: "#ED1946"
    }

    property QtObject errorDialog: QtObject {
        property color maskColor: "black"
        property color color: "#ED1D2B"
        property color textColor: "white"
        property font font: Qt.font({family: "Roboto Light"})
    }

    property QtObject infoDialog: QtObject {
        property color maskColor: "black"
        property color color: "#FFCE00"
        property color textColor: "white"
        property font font: Qt.font({family: "Roboto Light"})
    }

    property QtObject completer: QtObject {
        property color color: "black"
        property color hoverColor: "#ED1946"
        property color textColor: "#C1C0C0"
        property color scrollBarColor: "#9F9F9F"
        property var typeColors: ({})
        property font font: Qt.font({family: "Roboto Light"})

        Component.onCompleted: {
            typeColors[Expression.Function] = "#EF4223"
            typeColors[Expression.Variable] = "#C1C0C0"
        }
    }

    property QtObject countDown: QtObject {
        property var textColors: {0: "#ED1869", 1: "#F2BC1F", 2: "#39BFC1", 3: "#672980"}
        property font font: Qt.font({family: "Roboto Light"})
    }

    property QtObject resultSystemDisplay: QtObject {
        property color color: "#F2F2F2"
        property color baseTextColor: "#ED1D3D"
        property color valueTextColor: "#3D3D3D"
        property color scrollbarColor: "#ED1D3D"
        property font font: Qt.font({family: "Roboto Light"})
    }

    property QtObject functionSignatureDisplay: QtObject {
        property color color: "black"
        property color textColor: "white"
        property font font: Qt.font({family: "Roboto Light"})
    }
}
