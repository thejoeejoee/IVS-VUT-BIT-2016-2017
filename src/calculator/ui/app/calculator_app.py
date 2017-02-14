# coding=utf-8
import resources
from typing import List

from PyQt5.QtCore import QUrl
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication


class CalculatorApp(QApplication):
    def __init__(self, argv: List[str]):
        super().__init__(argv)

    @staticmethod
    def registerTypes():
        pass

    def run(self) -> int:
        CalculatorApp.registerTypes()

        engine = QQmlApplicationEngine()
        engine.load(QUrl("qrc:/calculator/ui/qml/main.qml"))

        return self.exec()