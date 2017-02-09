# coding=utf-8
from typing import Union

from PyQt5.QtCore import pyqtProperty, pyqtSignal
from PyQt5.QtGui import QColor
from PyQt5.QtQuick import QQuickPaintedItem, QQuickItem


class PaintedItem(QQuickPaintedItem):
    colorChanged = pyqtSignal("QColor")

    def __init__(self, parent: Union[None, QQuickItem] = None) -> None:
        super().__init__(parent)

        self._color = QColor()

    @pyqtProperty("QColor")
    def color(self) -> QColor:
        return self._color

    @color.setter
    def color(self, v):
        if self._color == v:
            return

        self._color = v
        self.colorChanged.emit(v)