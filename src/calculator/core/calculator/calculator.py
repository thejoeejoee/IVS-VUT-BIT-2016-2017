# coding=utf-8
from ast import Assign, Name
from typing import Dict, Tuple, Set

from calculator.core.solver.solver import Solver
from calculator.typing import NumericValue, Variable
from calculator.utils import OrderedDefaultDict
from calculator.exceptions import VariableError


class Calculator(object):
    """
    External API for calculator functionality including operating with variables & custom expressions.
    """

    ANSWER_VARIABLE_NAME = 'Ans'
    DEFAULT_VARIABLE_TYPE = int

    def __init__(self):
        super().__init__()

        self._variables = OrderedDefaultDict(
            default_factory=lambda: (0, '0', set()),  # TODO: return (default result, default source expression)
        )  # type: Dict[str, Variable]

        self._solver = Solver()

        self._variables[self.ANSWER_VARIABLE_NAME] = 0, '0', set()

    variables = property(lambda self: self._variables)

    def process(self, expression: str) -> Tuple[NumericValue, Dict[str, Variable]]:
        """
        Process mathematical expression with variables support, returning actual result and variables mapping.
        :param expression:
        :return:
        """
        root_node = self._solver.parser.parse(expression=expression)
        if isinstance(root_node, Assign):
            # TODO: resolve assign and create new variable from source expression
            if len(root_node.targets) != 1 or not isinstance(root_node.targets[0], Name):
                raise SyntaxError()

            value = self._solver.compute(root_node.value, self._variables)

            dependencies = self._solver.get_used_variables()

            # test recursive assign
            if self._has_circular_dependence(root_node.targets[0].id, dependencies):
                raise VariableError()

            self._variables[root_node.targets[0].id] = value, expression.split('=', 1)[1].strip(), dependencies
        else:
            pass  # TODO from known variables resolve via self.solver result of given expression and set to Ans

        return 0, self._variables

    def _has_circular_dependence(self, variable: str, dependencies: Set) -> bool:
        """
        Recursively tests if variable a has a circular dependence in given dependencies
        :param variable: variable identifier
        :param dependencies: set of dependencies to look in
        :return: True if circular dependency was found, otherwise False
        """
        if variable in dependencies:
            return True
        else:
            for dependency in dependencies:
                if dependency in self._variables:
                    var = self._variables.get(dependency)
                    if self._has_circular_dependence(variable, var[2]):
                        return True
            return False
