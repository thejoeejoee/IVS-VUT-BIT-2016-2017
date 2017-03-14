# coding=utf-8
from typing import Optional, Dict

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot
from PyQt5.QtCore import QVariant
from PyQt5.QtQml import QJSEngine
from PyQt5.QtQml import QQmlEngine

from calculator.core.calculator import Calculator
from calculator.exceptions import MathError


class UIAdapter(QObject):
    """
    Adapter, that connects UI signals to Calculator object, which handle the domain logic with variables.
    """

    processed = pyqtSignal(QVariant)

    def _set_calculator(self, calculator: Calculator) -> None:
        self._calculator = calculator

    @pyqtSlot(str)
    def process(self, expression: str):
        try:
            result = self._calculator.process(expression)

            self.processed.emit(QVariant({
                "result": result[0],
                "variables": result[1]
            }))

        except SyntaxError as e:
            pass  # TODO: syntax error of given expression
        except MathError as e:
            pass  # TODO: generic math error

    @staticmethod
    def singletonProvider(engine: QQmlEngine, script_engine: QJSEngine) -> QObject:
        adapter = UIAdapter()
        adapter._set_calculator(Calculator())
        return adapter
