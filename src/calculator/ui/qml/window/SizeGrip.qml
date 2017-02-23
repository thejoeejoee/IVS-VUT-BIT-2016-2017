import QtQuick 2.0
import QtQuick.Window 2.0

Item {
    id: component

    property Window target
    property bool resizing: false
    property point _startPoint
    property point _lastPoint

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.SizeFDiagCursor
        onPressed: {
            resizing = true
            _startPoint = Qt.point(mouse.x, mouse.y)
            _lastPoint = _startPoint
        }
        onReleased: {
            resizing = false
            component.anchors.rightMargin = 0
        }

        onPositionChanged: {
            if(!resizing)
                return
            component.anchors.rightMargin = mouse.x - _startPoint.x

            target.width += mouse.x - _lastPoint.x
            _lastPoint = Qt.point(mouse.x, mouse.y)
        }
    }
}
