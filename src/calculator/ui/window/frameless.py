# coding=utf-8
from typing import Union

from PyQt5.QtCore import Qt
from PyQt5.QtQuick import QQuickView
from PyQt5.QtWidgets import QWidget


class Frameless(QQuickView):
    def __init__(self, parent: Union[None, QWidget] = None) -> None:
        super().__init__(parent)

        self.setFlags(Qt.FramelessWindowHint)