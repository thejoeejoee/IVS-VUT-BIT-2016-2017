import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0

Item {
    id: component

    signal hide()
    signal show()
    signal moveUp()
    signal moveDown()
    signal chooseCurrent()
    signal itemChoosed()
    signal showAnimation()
    signal hideAnimation()

    property var currentItem: model[0]
    property int currentItemIndex: 0
    property int visibleItemCount: 4
    property alias scrollBarColor: scrollbar.color
    property alias scrollbarWidth: scrollbar.width

    readonly property bool dropMenuVisible: dropMenu.visible
    property int itemHeight
    property var model

    property Component dropDownMenuBackground
    property Component menuItem

    clip: true
    visible: false
    height: flick.height

    onModelChanged: currentItemIndex = 0

    onShow: {
        if(!component.visible)
            component.showAnimation()
    }

    onHide: {
        if(component.visible)
            component.hideAnimation()
    }

    onMoveUp: {
        if(component.currentItemIndex - 1 < 0) {
            component.currentItemIndex = component.model.length - 1
            flick.setViewPosIfNotVisible(component.itemHeight, component.itemHeight, (currentItemIndex - component.visibleItemCount + 1) * component.itemHeight)
        }

        else {
            component.currentItemIndex--
            flick.moveViewIfNotVisible(component.itemHeight, component.itemHeight, -component.itemHeight)
        }
    }

    onMoveDown: {
        if(component.currentItemIndex + 1 >= model.length) {
            component.currentItemIndex = 0
            flick.setViewPosIfNotVisible(component.itemHeight, component.itemHeight, currentItemIndex * component.itemHeight)
        }

        else {
            component.currentItemIndex++
            flick.moveViewIfNotVisible(component.itemHeight, component.itemHeight, component.itemHeight)
        }
    }

    onChooseCurrent: {
        component.currentItem = model[component.currentItemIndex]
        component.itemChoosed()
        component.hide()
    }

    onShowAnimation: SequentialAnimation {
        ScriptAction { script: { component.visible = true }}
        NumberAnimation {
            target: flick
            property: "y"
            from: -component.itemHeight * component.model.length
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    onHideAnimation: SequentialAnimation {
        NumberAnimation {
            target: flick
            property: "y"
            from: 0
            to: -component.itemHeight * component.model.length
            duration: 200
            easing.type: Easing.InOutQuad
        }
        ScriptAction { script: { component.visible = false }}
    }

    Rectangle {
        id: scrollbar

        z: 2
        y: flick.visibleArea.yPosition * flick.height + flick.y
        height: flick.visibleArea.heightRatio * flick.height
        opacity: flick.visibleArea.heightRatio != 1

        anchors.right: flick.right

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    Loader {
        sourceComponent: component.dropDownMenuBackground
        anchors.fill: flick
    }

    Flickable {
        id: flick

        contentHeight: component.model.length * component.itemHeight
        height: (component.model.length >= component.visibleItemCount)
                ?component.visibleItemCount * component.itemHeight
                :component.model.length * component.itemHeight
        width: parent.width
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: dropMenu

            width: component.width
            height: component.itemHeight * component.model.length

            Repeater {
                model: component.model
                delegate: Loader {
                    property var itemData: modelData
                    property bool hovered: (component.currentItemIndex == index)

                    sourceComponent: component.menuItem
                    clip: true

                    width: component.width
                    height: dropMenu.height / component.model.length

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: component.currentItemIndex = index
                        onClicked: component.chooseCurrent()
                    }
                }
            }
        }

        function setViewPosIfNotVisible(itemY, itemHeight, newPos)
        {
            if(!flick.itemIsVisible(currentItemIndex * itemHeight, itemHeight))
                flick.contentY = newPos
        }

        function moveViewIfNotVisible(itemY, itemHeight, newPos)
        {
            if(!flick.itemIsVisible(currentItemIndex * itemHeight, itemHeight))
                flick.contentY += newPos
        }

        function itemIsVisible(itemY, itemHeight) {
            if(itemY < flick.contentY)
                return false
            if(itemY + itemHeight > flick.contentY + flick.height)
                return false
            return true
        }
    }
}
