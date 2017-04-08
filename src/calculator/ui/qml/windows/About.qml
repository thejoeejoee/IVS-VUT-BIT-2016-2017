import QtQuick 2.5
import QtQuick.Window 2.0
import QtQuick.Controls 1.4

/**
  Component which displays info about Calculator app
  */
Item {
    id: component

    /**
      Used as function to display component
      */
    signal show
    /**
      Used as function to hide component
      */
    signal hide
    /**
      Emit after component is not visible anymore
      */
    signal hidden

    /// Padding of text in component
    property int padding: 20
    /// Revision from which is app released
    property string revision
    /// Background color of component
    property color color: "black"
    /// Text color
    property color textColor: "lightGray"
    /// Text color of title
    property alias titleColor: title.color
    /// Used font
    property font font

    visible: opacity
    focus: visible
    opacity: 0

    onShow: NumberAnimation { target: component; property: "opacity"; to: 1; duration: 200 }
    onHide: SequentialAnimation {
        NumberAnimation { target: component; property: "opacity"; to: 0; duration: 200 }
        ScriptAction { script: { component.hidden() } }
    }

    Keys.onEscapePressed: component.hide()

    MouseArea {
        anchors.fill: parent
        onClicked: component.hide()
    }

    Rectangle {
        color: component.color
        opacity: 0.8
        anchors.fill: parent
    }

    Rectangle {
        color: component.color

        width: 360
        height: 260

        anchors.centerIn: parent


        Image {
            source: "qrc:/assets/images/logo.svg"
            fillMode: Image.PreserveAspectFit
            opacity: 0.2

            width: parent.width * 0.7
            height: parent.height * 0.7

            sourceSize.width: width
            sourceSize.height: height

            anchors.centerIn: parent
        }

        Text {
            id: title

            text: qsTr("Barbie calculator 0.1")

            font.pixelSize: 25
            font.family: component.font.family

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: component.padding
            anchors.leftMargin: component.padding
        }

        Text {
            color: component.textColor
            font.pixelSize: 15
            font.family: component.font.family

            anchors.left: title.left
            anchors.top: title.bottom

            text: qsTr("From revision") + " - " + component.revision + "\n\n" +
                       qsTr("Created by:") + "\n" +
                       "    Josef Kolář\n" +
                       "    Son Hai Nguyen\n" +
                       "    Martin Omacht\n" +
                       "    Robert Navrátil\n\n" +
                       "Copyright 2016-2017 Syan Entertainment.\n" +
                       qsTr("All rights reserved.")
        }
    }
}
