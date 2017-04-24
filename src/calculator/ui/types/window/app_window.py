# coding=utf-8
from PyQt5.QtCore import QSize, pyqtProperty
from PyQt5.QtGui import QWindow, QResizeEvent
from PyQt5.QtQuick import QQuickWindow

__author__ = "Son Hai Nguyen"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class AppWindow(QQuickWindow):
    def __init__(self, parent: QWindow = None) -> None:
        super().__init__(parent)

        self.__ratio = 1

    def resizeEvent(self, e: QResizeEvent) -> None:
        new_width = e.size().width()
        new_height = new_width * self.__ratio

        self.setMinimumHeight(new_height)
        self.setMaximumHeight(new_height)
        self.contentItem().setProperty("width", new_width)
        self.contentItem().setProperty("height", new_height)

    @pyqtProperty(float)
    def ratio(self) -> float:
        return self.__ratio

    @ratio.setter
    def ratio(self, v: float) -> None:
        self.__ratio = v
