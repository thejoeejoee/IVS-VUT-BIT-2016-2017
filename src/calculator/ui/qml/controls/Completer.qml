import QtQuick 2.0
import QtQuick.Controls 2.0
import StyleSettings 1.0

DropDown {
    id: component

    property color color
    property var constantModel
    property var target
    property string currentText
    property color hoverColor
    property color textColor

    scrollbarWidth: 3
    model: constantModel

    onModelChanged: {
        if(!model.length)
            component.hide()
    }

    onCurrentTextChanged: {
        var newModel = []

        if(currentText.search(/^[ ]*$/) != -1) {
            component.model = constantModel
            return
        }

        for(var key in component.constantModel) {
            var value = component.constantModel[key]
            var currentTextWithoutSpace = currentText.replace(new RegExp("[ ]*(?=\\S+)", 'g'), "")

            // contains ")" which need to be escaped
            if(currentTextWithoutSpace.search(/\)/) !== -1)
                currentTextWithoutSpace = currentText.replace(/\)/g, "\\)")

            if(value["identifier"].search("^" + currentTextWithoutSpace) !== -1)
                newModel.push(value)
        }

        component.model = newModel
    }

    dropDownMenuBackground: Rectangle {
        color: component.color
        anchors.fill: parent
    }

    menuItem: Item {
        Rectangle {     // hover overlay
            opacity: 0.8
            color: (hovered) ?component.hoverColor :"transparent"

            anchors.fill: parent
        }

        Rectangle {
            id: symbol

            width: height
            height: component.itemHeight / 2
            color: StyleSettings.completer.typeColors[itemData["type"]]

            anchors.left: parent.left
            anchors.leftMargin: width
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            color: component.textColor
            text: itemData["identifier"]
            font.pixelSize: parent.height * 0.8
            anchors.left: symbol.right
            anchors.leftMargin: symbol.anchors.leftMargin
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
