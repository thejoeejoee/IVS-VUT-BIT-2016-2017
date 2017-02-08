from typing import List

from PyQt5.QtGui import QGuiApplication

from calculator.ui.mainwindow import CalculatorWindow


class CalculatorApp(QGuiApplication):
    def __init__(self, argv: List[str]):
        super().__init__(argv)

    def run(self) -> int:
        view = CalculatorWindow()
        view.show()

        return self.exec()