# coding=utf-8

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty, QVariant
from PyQt5.QtQml import QJSEngine, QQmlEngine

from calculator.settings import BUILTIN_FUNCTIONS, BUILTIN_FUNCTIONS_EXPANSION
from calculator.core.calculator import Calculator
from calculator.exceptions import MathError, VariableError


class UIAdapter(QObject):
    """
    Adapter, that connects UI signals to Calculator object, which handle the domain logic with variables.
    """

    processed = pyqtSignal(QVariant)
    _variables = dict()

    def _set_calculator(self, calculator: Calculator) -> None:
        self._calculator = calculator
        self._variables = self._calculator.variables.copy()

    @pyqtProperty(QVariant)
    def builtinFunctions(self) -> QVariant:
        return QVariant(list(BUILTIN_FUNCTIONS))

    @pyqtProperty(QVariant)
    def builtinFunctionsExpansion(self) -> QVariant:
        return QVariant({func_name: expansion for (func_name, expansion) in BUILTIN_FUNCTIONS_EXPANSION})

    @pyqtSlot(str)
    def removeVariable(self, variable_identifier: str) -> None:
        print(variable_identifier)
        self._calculator.remove_variable(variable_identifier)
        self._variables = self._calculator.variables.copy()

    @pyqtSlot(str)
    def process(self, expression: str) -> None:
        try:
            result, variables = self._calculator.process(expression)

            new_variables = (set(variables.keys()) - set(self._variables.keys())) - {
                Calculator.ANSWER_VARIABLE_NAME
            }
            modified_variable = {key for key, value in self._variables.items() if value != variables.get(key)}

            self.processed.emit(QVariant({
                "result": result,
                "variables": {
                    key: dict(value=value, expression=expression)
                    for key, (value, expression, _)
                    in variables.items()
                },
                "variablesDiff": {
                    "new": list(new_variables),
                    "modified": list(modified_variable)
                }
            }))

            self._variables = variables
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
