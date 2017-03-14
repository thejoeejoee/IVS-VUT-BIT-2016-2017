# coding=utf-8

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot
from PyQt5.QtCore import QVariant
from PyQt5.QtQml import QJSEngine
from PyQt5.QtQml import QQmlEngine

from calculator.core.calculator import Calculator
from calculator.exceptions import MathError, VariableError


class UIAdapter(QObject):
    """
    Adapter, that connects UI signals to Calculator object, which handle the domain logic with variables.
    """

    processed = pyqtSignal(QVariant)
    variables = dict()

    def _set_calculator(self, calculator: Calculator) -> None:
        self._calculator = calculator

    @pyqtSlot(str)
    def process(self, expression: str):
        try:
            result, variables = self._calculator.process(expression)

            created_variables = set(self.variables.keys()) - set(variables.keys())
            changed_variables = {key for key, value in self.variables.items() if value != variables.get(key)}

            self.processed.emit(QVariant({
                "result": result,
                "variables": variables
            }))

            self.variables = variables
        except SyntaxError as e:
            pass  # TODO: syntax error of given expression
        except MathError as e:
            pass  # TODO: generic math error
        except VariableError as e:
            pass  # TODO: problem with vars

    @staticmethod
    def singletonProvider(engine: QQmlEngine, script_engine: QJSEngine) -> QObject:
        adapter = UIAdapter()
        adapter._set_calculator(Calculator())
        return adapter
