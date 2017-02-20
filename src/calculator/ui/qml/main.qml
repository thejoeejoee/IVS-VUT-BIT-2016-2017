import QtQuick 2.7
import QtQuick.Controls 1.4
import "window" as Window
import "loaders" as Loaders

Window.CustomWindow {
    id: mainWindow
    width: 640
    height: 480

    Loaders.FontsLoader {}
}
