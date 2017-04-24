/**************************************************************************
**   Calculator
**   Copyright (C) 2017 /dej/uran/dom team
**   Authors: Son Hai Nguyen
**   Credits: Josef Kolář, Son Hai Nguyen, Martin Omacht, Robert Navrátil
**
**   This program is free software: you can redistribute it and/or modify
**   it under the terms of the GNU General Public License as published by
**   the Free Software Foundation, either version 3 of the License, or
**   (at your option) any later version.
**
**   This program is distributed in the hope that it will be useful,
**   but WITHOUT ANY WARRANTY; without even the implied warranty of
**   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**   GNU General Public License for more details.
**
**   You should have received a copy of the GNU General Public License
**   along with this program.  If not, see <http://www.gnu.org/licenses/>.
**************************************************************************/
import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.0

/**
  Base dropdown menu, to select one item
  */
Item {
    id: component

    /**
      Used as function to hide dropdown
      */
    signal hide()
    /**
      Used as function to show dropdown
      */
    signal show()
    /**
      Used as function to move upward item selection of item
      */
    signal moveUp()
    /**
      Used as function to move downward item selection of item
      */
    signal moveDown()
    /**
      Used as function to choose selected item
      */
    signal chooseCurrent()
    /**
      Emit when item was chosen
      */
    signal itemChoosed()
    /**
      Signal to start show animation
      */
    signal showAnimation()
    /**
      Signal to start hide animation
      */
    signal hideAnimation()

    /// Holds chosen item
    property var currentItem: model[0]
    /// Holds seleted item index
    property int currentItemIndex: 0
    /// Number of visible items without scroll
    property int visibleItemCount: 4
    /// Color of scrollbar
    property alias scrollBarColor: scrollbar.color
    /// Width of scrollbar
    property alias scrollbarWidth: scrollbar.width

    /// Holds whether component is shown
    readonly property bool dropMenuVisible: dropMenu.visible
    /// Height of single selection item
    property int itemHeight
    /// List of labels to be generation into items in dropdown
    property var model

    /// Component which will be loaded to represent background
    property Component dropDownMenuBackground
    /// Component which will be loaded to represent single dropdown item
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

    MouseArea {
        parent: root
        enabled: component.visible
        anchors.fill: parent
        onClicked: component.hide()
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
                        signal checkMousePos

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: component.chooseCurrent()
                        onMouseXChanged: checkMousePos()
                        onMouseYChanged: checkMousePos()
                        onContainsMouseChanged: checkMousePos()
                        onCheckMousePos: {
                            if(containsMouse && flick.y == 0)
                                component.currentItemIndex = index
                        }
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
