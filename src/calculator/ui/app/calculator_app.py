# coding=utf-8
from PyQt5.QtCore import QObject

import resources
from typing import List, Optional

from calculator.ui.qmlwrapper.core import Sides

from PyQt5.QtCore import QUrl
from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType
from PyQt5.QtWidgets import QApplication


class CalculatorApp(QApplication):
    def __init__(self, argv: List[str]):
        super().__init__(argv)

    @staticmethod
    def registerTypes():
        qmlRegisterSingletonType(Sides, "Sides", 1, 0, "Sides", Sides.singletonProvider)

    def run(self) -> int:
        CalculatorApp.registerTypes()

        engine = QQmlApplicationEngine()
        engine.load(QUrl("qrc:/calculator/ui/qml/main.qml"))

        return self.exec()