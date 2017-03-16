pragma Singleton
import QtQuick 2.0
import QtQuick.Controls.Styles 1.4

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
        property font font: styles.variablesPanel.font
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
}
