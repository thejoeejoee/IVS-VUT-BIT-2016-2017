# coding=utf-8
from ast import Assign, Name
from typing import Dict, Tuple, Set, Optional

from calculator.core.solver.solver import Solver
from calculator.exceptions import VariableError
from calculator.typing import NumericValue, Variable
from calculator.utils import OrderedDefaultDict


class Calculator(object):
    """
    External API for calculator functionality including operating with variables & custom expressions.
    """

    ANSWER_VARIABLE_NAME = 'Ans'
    DEFAULT_VARIABLE_TYPE = int

    def __init__(self):
        super().__init__()
        self._solver = Solver()

        self._variables = OrderedDefaultDict(
            default_factory=lambda: (
                self.DEFAULT_VARIABLE_TYPE(),
                str(self.DEFAULT_VARIABLE_TYPE()),
                set(),
            ),
        )  # type: Dict[str, Variable]

        # manually create default answer variable
        _ = self._variables[self.ANSWER_VARIABLE_NAME]

    variables = property(lambda self: self._variables)  # type: Dict[str, Variable]

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

            value = self._solver.compute(root_node.value, self.variables)

            dependencies = self._solver.get_used_variables()

            # test recursive assign
            variable_name = root_node.targets[0].id
            if self._has_circular_dependence(variable_name, dependencies):
                raise VariableError(
                    "Assignment to a variable '{variable_name}' would create a circular dependency.".format(
                        variable_name=variable_name
                    ))

            self._variables.update(self._solver.variables)  # get new variables from Solver
            self._variables[variable_name] = value, expression.split('=', 1)[1].strip(), dependencies  # create new var.

            for key, var in self._variables.items():
                if variable_name in var[2]:  # if var depends on changed variable
                    if key == self.ANSWER_VARIABLE_NAME:
                        self.process(var[1])
                    else:
                        self.process(key + " = " + var[1])  # recursively update dependent variable
        else:
            result = self._solver.compute(expression, self.variables)
            self._variables.update(self._solver.variables)
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
