import QtQuick 2.0

/**
  Simple countdown display only number of remaining time
  */
Item {
    id: component

    /**
      Start countdown and display component
      @param seconds Count of seconds to be counted down
      */
    signal start(int seconds)
    /**
      Emits after time runs out
      */
    signal triggered()

    /// Holds current remaining time in seconds
    readonly property alias count: timer.count
    /// Text color of numbers
    property alias color: text.color
    /// Font of text
    property font font

    focus: visible
    visible: opacity
    opacity: 0

    onStart: {
        component.opacity = 1
        timer.count = seconds
        timer.start()
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    MouseArea {
        anchors.fill: parent
    }

    Text {
        id: text

        font.pixelSize: parent.height / 1.2
        font.family: component.font.family

        anchors.centerIn: parent
    }

    Timer {
        id: timer

        property int count

        interval: 1000
        running: false
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if(!timer.count) {
                timer.stop()
                component.opacity = 0
                component.triggered()
            }

            else
                text.text = timer.count.toString()
            timer.count--
        }
    }
}
