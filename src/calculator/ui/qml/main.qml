import QtQuick 2.7
import QtQuick.Controls 1.4
import ExpSyntaxHighlighter 1.0
import "window" as Window

Window.CustomWindow {
    id: mainWindow
    width: 640
    height: 480

    Item {
        ExpSyntaxHighlighter {
            id: esh
            target: te
        }
    }

    TextEdit {
        id: te
        width: 100
        height: 100
        color: "blue"
    }
}
