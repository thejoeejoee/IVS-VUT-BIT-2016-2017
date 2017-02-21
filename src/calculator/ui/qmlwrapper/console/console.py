# coding=utf-8
from typing import Union

from PyQt5.QtCore import QObject, pyqtSlot


class Console(QObject):
    def __init__(self, parent: Union[None, QObject] = None) -> None:
        super().__init__(parent)

    @pyqtSlot(str)
    def print(self, v: str) -> None:
        print("QML:", v)