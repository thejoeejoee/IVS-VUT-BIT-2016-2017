# coding=utf-8
# noinspection PyUnresolvedReferences
import calculator.ui.resources
from typing import List

from calculator.ui.qmlwrapper.core import Sides

from PyQt5.QtCore import QUrl, QObject
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
        engine.load(QUrl("qrc:/qml/main.qml"))

        return self.exec()