# coding=utf-8
from typing import Optional

from PyQt5.QtCore import QObject, pyqtSignal
from PyQt5.QtCore.QVariant import QVariant

from calculator.core.calculator import Calculator
from calculator.exceptions import MathError


class UIAdapter(QObject):
    """
    Adapter, that connects UI signals to Calculator object, which handle the domain logic with variables.
    """
    _calculator = None
    processed = pyqtSignal(QVariant, list)

    def __init__(self, parent=Optional[QObject]):
        super().__init__(parent=parent)

    def set_calculator(self, calculator: Calculator):
        self._calculator = calculator

    calculator = property(fset=set_calculator)

    def process(self, expression: str):
        try:
            self._calculator.process(expression)
        except SyntaxError as e:
            pass  # TODO: syntax error of given expression
        except MathError as e:
            pass  # TODO: generic math error
