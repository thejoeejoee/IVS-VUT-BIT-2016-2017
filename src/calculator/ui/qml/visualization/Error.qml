import QtQuick 2.0
import "../controls" as Controls

Item {
    id: component

    signal hide()
    signal show(string error)
    signal hideAnimation()
    signal showAnimation()

    property alias maskColor: mask.color
    property alias dialogColor: dialog.color
    property alias textColor: errorText.color
    property alias errorMessage: errorMsg.text
    property font font

    visible: false
    opacity: 0
    focus: visible
    Keys.onPressed: component.hide()

    onShow: {
        component.errorMessage = error
        component.showAnimation()
    }

    onHide: component.hideAnimation()

    onShowAnimation: SequentialAnimation {
        ScriptAction { script: { component.visible = true }}
        NumberAnimation { target: component; property: "opacity"; to: 1; from: 0; duration: 300 }
    }

    onHideAnimation: SequentialAnimation {
        NumberAnimation { target: component; property: "opacity"; to: 0; from: 1; duration: 300 }
        ScriptAction { script: { component.visible = false }}
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
            id: errorText

            text: qsTr("Error")

            font.pixelSize: parent.height / 3
            font.family: component.font.family

            anchors.left: parent.left
            anchors.leftMargin: font.pixelSize / 2
            anchors.top: parent.top
            anchors.topMargin: font.pixelSize / 8
        }

        Text {
            id: errorMsg

            color: errorText.color

            font.pixelSize: parent.height / 7
            font.family: component.font.family

            anchors.left: errorText.left
            anchors.top: errorText.bottom
            anchors.topMargin: parent.height / 25
        }

        Controls.DefaultButton {
            text: qsTr("Ok")
            color: errorText.color
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
