import QtQuick 2.0
import QtQuick.Controls 2.0
import StyleSettings 1.0

// TODO styles
DropDown {
    id: component

    property color color: "white"
    property var constantModel
    property var target
    property string currentText

    scrollbarWidth: 4
    model: constantModel

    onCurrentTextChanged: {
        var newModel = []

        for(var key in component.constantModel) {
            var value = component.constantModel[key]

            if(value.search("^" + currentText) !== -1)
                newModel.push(value)
        }

        component.model = newModel
    }

    dropDownMenuBackground: Rectangle {
        color: "transparent"
        border.width: 1
        border.color: component.color
    }

    menuItem: Rectangle {
        color: (hovered) ?"blue" :"red"

        Text {
            color: "white"
            text: itemData
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    onTargetChanged: {
        component.target.Keys.pressed.connect(component.handleOtherKeys)
        component.target.Keys.upPressed.connect(component.moveUp)
        component.target.Keys.downPressed.connect(component.moveDown)
    }

    function handleOtherKeys(event) {
        if(event.key == Qt.Key_Space && (event.modifiers & Qt.ControlModifier)) {
            component.show()
            event.accepted = true
        }

        if(component.visible && component.model.length) {
            switch(event.key) {
                case Qt.Key_Return:
                case Qt.Key_Enter:
                    component.chooseCurrent()
                    break;
                case Qt.Key_Escape:
                    component.hide()
                    break;
            }
        }
    }
}
