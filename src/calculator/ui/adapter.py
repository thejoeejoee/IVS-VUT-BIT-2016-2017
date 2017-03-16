# coding=utf-8
from typing import Dict, Tuple, Set

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty, QVariant
from PyQt5.QtQml import QJSEngine, QQmlEngine

from calculator.core.calculator import Calculator
from calculator.exceptions import MathError, VariableError
from calculator.settings import BUILTIN_FUNCTIONS, EXPRESSION_EXPANSIONS, HIGHLIGHT_RULES
from calculator.typing import Variable, NumericValue
from calculator.utils.translate import translate


class UIAdapter(QObject):
    """
    Adapter, that connects UI signals to Calculator object, which handle the domain logic with variables.
    """

    processed = pyqtSignal(QVariant)
    _variables = dict()  # type: Dict[str, Variable]

    def _set_calculator(self, calculator: Calculator) -> None:
        self._calculator = calculator

        self._commit_new_variables_state(variables=calculator.variables)

    def _commit_new_variables_state(self, variables: Dict[str, Variable]) -> Tuple[Set[str], Set[str]]:
        """
        Commits the new state of variables dict, returning created and modified variables.
        :param variables: dict of actual variables
        :return: tuple of created variables and modified variables, both as Set of variable names
        """

        created_variables = (set(variables.keys()) - set(self._variables.keys())) - {
            Calculator.ANSWER_VARIABLE_NAME
        }
        changed_variables = {key for key, value in self._variables.items() if value != variables.get(key)}

        self._variables = variables.copy()

        return created_variables, changed_variables

    @pyqtSlot(str, int)
    def setVariableValue(self, variable: str, value: NumericValue):
        try:
            _, variables = self._calculator.process_variable(variable=variable, expression=str(value))
        except MathError as e:
            variables = dict()
            pass  # eg zero divide

        created_variables, modified_variables = self._commit_new_variables_state(variables=variables)

        self.processed.emit(QVariant({
            "result": None,
            "variables": {
                key: dict(value=value, expression=expression)
                for key, (value, expression, _)
                in variables.items()
                },
            "variablesDiff": {
                "new": list(created_variables),
                "modified": list(modified_variables)
            }
        }))

    @pyqtProperty(QVariant)
    def highlightRules(self) -> QVariant:
        return QVariant([dict(pattern=pattern, color=color)
                         for (pattern, color) in HIGHLIGHT_RULES]
                        )

    @pyqtProperty(QVariant)
    def builtinFunctions(self) -> QVariant:
        return QVariant(list(BUILTIN_FUNCTIONS))

    @pyqtProperty(QVariant)
    def expressionsExpansion(self) -> QVariant:
        return QVariant({expression: dict(expansion=expansion, expansionType=expansion_type)
                         for expression, expansion, expansion_type in EXPRESSION_EXPANSIONS})

    @pyqtSlot(str)
    def removeVariable(self, variable_identifier: str) -> None:
        print(variable_identifier)
        self._calculator.remove_variable(variable_identifier)
        self._variables = self._calculator.variables.copy()

    @pyqtSlot(str)
    def process(self, expression: str) -> None:
        try:
            result, variables = self._calculator.process(expression)

            created_variables, modified_variables = self._commit_new_variables_state(variables=variables)

            self.processed.emit(QVariant({
                "result": result,
                "variables": {
                    key: dict(value=value, expression=expression)
                    for key, (value, expression, _)
                    in variables.items()
                },
                "variablesDiff": {
                    "new": list(created_variables),
                    "modified": list(modified_variables)
                }
            }))

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
