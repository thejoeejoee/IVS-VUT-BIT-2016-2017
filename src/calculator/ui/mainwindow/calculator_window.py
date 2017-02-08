# coding=utf-8
import resources

from typing import Union

from PyQt5.QtCore import QUrl, Qt
from PyQt5.QtQuick import QQuickView
from PyQt5.QtWidgets import QWidget
from termcolor import colored

from calculator.ui.qmlwrapper.console import Console
from calculator.ui.window import Frameless


class CalculatorWindow(Frameless):
    def __init__(self, parent: Union[None, QWidget] = None) -> None:
        super().__init__(parent)

        self.statusChanged.connect(self._handleQmlError)
        self.setColor(Qt.transparent)

        self._console = Console()
        self.rootContext().setContextProperty("io", self._console)
        self.setSource(QUrl('./calculator/ui/qml/main.qml'))

        # set root object properties
        self.rootObject().setProperty("color", "transparent")

    def _handleQmlError(self, status: QQuickView.Status) -> None:
        if status != QQuickView.Error:
            return

        errors = self.errors()

        if errors:
            for err in errors:
                print("ERROR: File: {0} on line {1}: {2}".format(
                    err.url().toString(),
                    err.line(),
                    colored(err.description(), "red"))
                )