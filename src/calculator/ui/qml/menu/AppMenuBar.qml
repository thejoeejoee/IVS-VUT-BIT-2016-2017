import QtQuick 2.0
import "../controls"

/**
  Component which has same functionality as MenuBar, but it does not affect window
  container size.
  */
Canvas {
    id: component

    /**
      Emits after clicking on item in menu
      @param item Label of item
      */
    signal itemChoosed(string item)

    /// Background color of bar
    property color color
    /// Text margins of title
    property int titleMargins: 10
    /// Title text
    property alias title: label.text
    /// Text color of title
    property alias titleColor: label.color
    /// Text color of title, when it's active
    property color titleActiveColor
    /// List of items in menu
    property alias items: menu.model
    /// Width of menu
    property alias menuWidth: menu.width
    /// Height of single item in menu
    property alias menuItemHeight: menu.itemHeight
    /// Background color of item in menu
    property color itemBackgroundColor
    /// Border color of item in menu
    property color itemBorderColor
    /// Hover color of item in menu
    property color itemHoverColor
    /// Text color of item in menu
    property color itemTextColor
    /// Hover text color of item in menu
    property color itemHoverTextColor
    /// Used font
    property font font

    onColorChanged: component.requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, component.width, component.height)

        ctx.fillStyle = component.color

        // draw shape
        //|------------/
        //|-----------/

        ctx.beginPath()
        ctx.moveTo(0, 0)
        ctx.lineTo(component.width, 0)
        ctx.lineTo(component.width - component.height, component.height)
        ctx.lineTo(component.width, component.height)
        ctx.lineTo(0, component.height)
        ctx.lineTo(0, 0)

        ctx.fill()
    }

    Rectangle {
        id: title

        color: (menu.visible) ?component.titleActiveColor :"transparent"
        width: label.width + 2 * component.titleMargins
        height: component.height

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        Text {
            id: label

            font.pixelSize: component.height * 0.8
            font.family: component.font.family

            anchors.centerIn: parent
        }
    }

    Item {
        y: component.height

        DropDown {
            id: menu

            onItemChoosed: component.itemChoosed(menu.currentItem)

            dropDownMenuBackground: Rectangle {
                color: component.itemBackgroundColor
                border.color: component.itemBorderColor
                anchors.fill: parent
            }

            menuItem: Item {
                Rectangle {     // hover overlay
                    opacity: 0.8
                    color: (hovered) ?component.itemHoverColor :"transparent"

                    anchors.fill: parent
                }

                Text {
                    color: (hovered) ?component.itemHoverTextColor :component.itemTextColor
                    text: itemData

                    font.family: component.font.family
                    font.pixelSize: parent.height * 0.8

                    anchors.leftMargin: menu.itemHeight / 2
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: menu.show()
    }
}
