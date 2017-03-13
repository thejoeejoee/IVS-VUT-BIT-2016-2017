pragma Singleton
import QtQuick 2.0
import QtQuick.Controls.Styles 1.4

QtObject {
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

    /*property QtObject codeEditor: QtObject {
        property color lineNumbersTextColor: "gray"
        property color lineNumbersColor: "#f2f2f2"
    }*/
}
