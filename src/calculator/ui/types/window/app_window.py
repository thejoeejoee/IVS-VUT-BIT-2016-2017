# coding=utf-8
from PyQt5.QtCore import QSize
from PyQt5.QtCore import qDebug
from PyQt5.QtGui import QResizeEvent
from PyQt5.QtGui import QWindow
from PyQt5.QtQuick import QQuickWindow


class AppWindow(QQuickWindow):
    def __init__(self, parent: QWindow = None) -> None:
        super().__init__(parent)

        self.setTitle("Barbie Calculator")
        self.setWidth(1101)
        self.setHeight(522)


    def resizeEvent(self, e: QResizeEvent) -> None:
        ee = QResizeEvent(QSize(e.size().width(), 522), e.oldSize())
        new_width = e.size().width()
        new_height = (new_width / 1101) * 522

        self.setMinimumHeight(new_height)
        self.setMaximumHeight(new_height)
        self.contentItem().setProperty("width", new_width)
        self.contentItem().setProperty("height", new_height)