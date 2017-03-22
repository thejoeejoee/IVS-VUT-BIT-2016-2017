import QtQuick 2.0
import "../controls" as Controls

/**
  Base for modal PopUp dialogs
  */
Item {
    id: component

    /**
      Used as function to hide component
      */
    signal hide()
    /**
      Emits after component is hidden
      */
    signal hidden()
    /**
      Used as function to show component
      @param msg Message to be displayed
      */
    signal show(string msg)
    /**
      Signal to start show animation
      */
    signal showAnimation()
    /**
      Signal to start hide animation
      */
    signal hideAnimation()

    /// Background color of modal
    property alias maskColor: mask.color
    /// Background color of dialog
    property alias dialogColor: dialog.color
    /// Text color
    property alias textColor: title.color
    /// Text to be displayed in dialog
    property alias message: message.text
    /// Title of dialog
    property alias title: title.text
    /// Used font
    property font font

    visible: false
    opacity: 0
    focus: visible
    Keys.onPressed: component.hide()

    onShow: {
        component.message = msg
        component.showAnimation()
    }

    onHide: component.hideAnimation()

    onShowAnimation: SequentialAnimation {
        ScriptAction { script: { component.visible = true }}
        NumberAnimation { target: component; property: "opacity"; to: 1; from: 0; duration: 300 }
    }

    onHideAnimation: SequentialAnimation {
        NumberAnimation { target: component; property: "opacity"; to: 0; from: 1; duration: 300 }
        ScriptAction { script: { component.visible = false; component.hidden() }}
    }

    Rectangle {
        id: mask

        opacity: 0.8
        anchors.fill: parent
    }

    MouseArea {     // block mouse events
        anchors.fill: parent
    }

    Rectangle {
        id: dialog

        width: parent.width
        height: parent.height / 3

        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: title

            font.pixelSize: parent.height / 3
            font.family: component.font.family

            anchors.left: parent.left
            anchors.leftMargin: font.pixelSize / 2
            anchors.top: parent.top
            anchors.topMargin: font.pixelSize / 8
        }

        Text {
            id: message

            color: title.color

            font.pixelSize: parent.height / 7
            font.family: component.font.family

            anchors.left: title.left
            anchors.top: title.bottom
            anchors.topMargin: parent.height / 25
        }

        Controls.DefaultButton {
            text: qsTr("Ok")
            color: title.color
            backgroundColor: component.dialogColor
            font.family: component.font.family

            width: parent.width / 8
            height: width / 5

            anchors.right: parent.right
            anchors.rightMargin: height
            anchors.bottomMargin: height / 1.5
            anchors.bottom: parent.bottom

            onClicked: hide()
        }
    }
}
