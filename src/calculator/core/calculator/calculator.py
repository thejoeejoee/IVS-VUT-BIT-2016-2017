# coding=utf-8
from ast import Assign, Name
from typing import Dict, Tuple, Set, Optional

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

    def process(self, expression: str) -> Tuple[Optional[NumericValue], Dict[str, Variable]]:
        """
        Process mathematical expression with variables support, returning actual result and variables mapping.
        :param expression:
        :return:
        """
        root_node = self._solver.parser.parse(expression=expression)
        result = None
        if isinstance(root_node, Assign):
            # TODO: restriction for reserved variable names
            if len(root_node.targets) != 1 or not isinstance(root_node.targets[0], Name):
                raise SyntaxError('Assign to multiple variables or to indexed variable is not supported.')

            value = self._solver.compute(root_node.value, self._variables)

            dependencies = self._solver.get_used_variables()

            # test recursive assign
            variable_name = root_node.targets[0].id
            if self._has_circular_dependence(variable_name, dependencies):
                raise VariableError("Assignment to a variable '{variable_name}' would create a circular dependency.".format(
                    variable_name=variable_name
                ))

            self._variables[variable_name] = value, expression.split('=', 1)[1].strip(), dependencies
            self._variables.update(self._solver.get_variable_dict())

            # TODO: update variables that depend on changed variable, only if it existed before
        else:
            result = self._solver.compute(expression, self._variables)
            self._variables.update(self._solver.get_variable_dict())
            self._variables[self.ANSWER_VARIABLE_NAME] = result, expression, self._solver.get_used_variables()

        return result, self._variables

    def _has_circular_dependence(self, variable: str, dependencies: Set[str]) -> bool:
        """
        Recursively tests if variable a has a circular dependence in given dependencies
        :param variable: variable identifier
        :param dependencies: set of dependencies to look in
        :return: True if circular dependency was found, otherwise False
        """
        if variable in dependencies:
            return True

        for dependency in dependencies:
            if dependency in self._variables:  # if it's known variable, check it's dependencies
                if self._has_circular_dependence(variable, self._variables.get(dependency)[2]):
                    return True
        return False
