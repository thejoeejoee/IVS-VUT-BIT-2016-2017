# coding=utf-8
import re

from typing import Dict, Tuple, Set

from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot, pyqtProperty, QVariant
from PyQt5.QtQml import QJSEngine, QQmlEngine

from calculator.core.calculator import Calculator
from calculator.exceptions import MathError, VariableError
from calculator.typing import Variable, NumericValue
from calculator.utils.number_formatter import NumberFormatter
from calculator.utils.translate import translate
from calculator.settings import (BUILTIN_FUNCTIONS, EXPRESSION_EXPANSIONS, HIGHLIGHT_RULES, EXPRESSION_SPLITTERS,
                                 Expression)


class UIAdapter(QObject):
    """
    Adapter, that connects UI signals to Calculator object, which handle the domain logic with variables.
    """

    identifiersTypesChanged = pyqtSignal(QVariant)
    processed = pyqtSignal(QVariant)
    error = pyqtSignal(str)
    _variables = dict()  # type: Dict[str, Variable]
    _formatter = NumberFormatter
    func_identifiers_types = [{"identifier": func, "type": Expression.ExpressionTypes.Function}
                              for func in BUILTIN_FUNCTIONS]

    @pyqtSlot(str)
    def process(self, expression: str) -> None:
        try:
            result, variables = self._calculator.process(expression)

            created_variables, modified_variables = self._commit_new_variables_state(variables=variables)

            self.identifiersTypesChanged.emit(self.identifiersTypes)
            self.processed.emit(QVariant({
                "result": None if result is None else self._formatter.format(result, 16),
                "variables": {
                    key: dict(
                        value=self._formatter.format(value),
                        expression=self._format_source_expression(
                            variable=key,
                            source_expression=expression
                        )
                    )
                    for key, (value, expression, _)
                    in variables.items()
                    },
                "variablesDiff": {
                    "new": list(created_variables),
                    "modified": list(modified_variables)
                }
            }))

        except SyntaxError as e:
            self.error.emit(translate("Adapter", "Expression contains syntax error."))
        except MathError as e:
            self.error.emit(translate("Adapter", "Math error occured."))
        except VariableError as e:
            self.error.emit(translate("Adapter", "Error in defining variable."))
        except OverflowError:
            self.error.emit(translate("Adapter", "Result is too big."))

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
                key: dict(
                    value=self._formatter.format(value),
                    expression=self._format_source_expression(
                        variable=key,
                        source_expression=expression
                    )
                )
                for key, (value, expression, _)
                in variables.items()
                },
            "variablesDiff": {
                "new": list(created_variables),
                "modified": list(modified_variables)
            }
        }))

    @pyqtSlot(str)
    def removeVariable(self, variable_identifier: str) -> None:
        print(variable_identifier)
        self._calculator.remove_variable(variable_identifier)
        self._variables = self._calculator.variables.copy()

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

    @staticmethod
    def singletonProvider(engine: QQmlEngine, script_engine: QJSEngine) -> QObject:
        adapter = UIAdapter()
        adapter._set_calculator(Calculator())
        return adapter

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

    @pyqtProperty(QVariant)
    def expressionSplitters(self) -> QVariant:
        return QVariant(list(EXPRESSION_SPLITTERS))

    @pyqtProperty(str)
    def expressionSplittersRegExp(self) -> str:
        result = re.escape("".join(EXPRESSION_SPLITTERS))
        return "".join(("[", result ,"]"))

    @pyqtProperty(QVariant, notify=identifiersTypesChanged)
    def variables(self) -> QVariant:
        return QVariant(list(self._calculator.variables.keys()))

    #TODO notify
    @pyqtProperty(QVariant, notify=identifiersTypesChanged)
    def identifiersTypes(self):
        return [{"identifier": var_identifier, "type": Expression.ExpressionTypes.Variable}
                for var_identifier in sorted(self._calculator.variables.keys())] + \
               UIAdapter.func_identifiers_types

    @staticmethod
    def _format_source_expression(variable: str, source_expression: str) -> str:
        """
        From source expression strips the variable name and whitespace before =.
        :param variable: variable name
        :param source_expression: source expression for variable
        :return: striped source expression
        """
        return source_expression.lstrip(variable).lstrip()
