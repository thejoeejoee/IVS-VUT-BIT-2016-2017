# coding=utf-8
from ast import Assign, Name, Pass
from typing import Dict, Tuple, Set, Optional

from calculator.core.solver.solver import Solver
from calculator.exceptions import VariableError, VariableRemoveRestrictError, VariableNameError
from calculator import NumericValue, Variable
from calculator.utils import OrderedDefaultDict


class Calculator(object):
    """
    External API for calculator functionality including operating with variables & custom expressions.
    """

    ANSWER_VARIABLE_NAME = 'Ans'
    DEFAULT_VARIABLE_TYPE = int
    MAX_VARIABLE_NAME_LEN = 10

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

            variable_name = root_node.targets[0].id
            if len(variable_name) > self.MAX_VARIABLE_NAME_LEN:
                raise VariableNameError('Variable name "{var}" is too long (max {max} characters.)'
                                        .format(var=variable_name, max=self.MAX_VARIABLE_NAME_LEN))

            value = self._solver.compute(root_node.value, self.variables)
            used_variables = self._solver.get_used_variables()

            # test recursive assign
            if self._has_circular_dependence(variable_name, used_variables):
                raise VariableError(
                    "Assignment to a variable '{variable_name}' would create a circular dependency.".format(
                        variable_name=variable_name
                    ))

            # update by new created variables from Solver
            self._variables.update(self._solver.variables)
            # create new var
            self._variables[variable_name] = value, expression, used_variables
            # and refresh all depending
            self._refresh_variable_with_dependencies(variable=variable_name)
        elif isinstance(root_node, Pass):
            pass
        else:
            # simple expression
            result = self._solver.compute(expression, self.variables)
            # update new vars used by solver resolved from expression
            self._variables.update(self._solver.variables)
            self._variables[self.ANSWER_VARIABLE_NAME] = result, expression, self._solver.get_used_variables()

        return result, self._variables.copy()

    def process_variable(self, variable: str, expression: str) -> Tuple[Optional[NumericValue], Dict[str, Variable]]:
        """
        Overridden process to set variable directly by expression.
        :param variable: variable name
        :param expression: expression to set
        :return: result and variables, same as standard process
        """
        return self.process('{variable} = {expression}'.format(
            variable=variable,
            expression=expression
        ))

    def remove_variable(self, variable: str) -> None:
        """
        Removes variable from calculator, if there are any depending vars, VariableRemoveRestrictError is raised.
        :param variable: variable name
        :return: nothing to return
        """
        if variable not in self.variables:
            raise VariableError("Unknown variable '{}' to remove.".format(variable))

        dependencies = self._get_depending_variables(variable=variable) - {Calculator.ANSWER_VARIABLE_NAME}
        if dependencies:
            raise VariableRemoveRestrictError(dependencies=dependencies)

        del self._variables[variable]

    def _refresh_variable_with_dependencies(self, variable: str) -> None:
        """
        Refresh given variable with all depending variables recursive.
        :param variable: variable name
        :return: nothing important to return
        """
        _, source_expression, dependencies = self.variables[variable]
        # recompute the value from variables
        computed_value = self._solver.compute(source_expression, self.variables)
        # set new value
        self.variables[variable] = computed_value, source_expression, dependencies

        for depending_variable in self._get_depending_variables(variable):
            # and refresh all depending vars
            self._refresh_variable_with_dependencies(depending_variable)

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
            if dependency not in self._variables:  # skip not known variables
                continue
            # else recursive check dependent variables
            _, _, current_variable_dependencies = self._variables.get(dependency)
            if self._has_circular_dependence(variable, current_variable_dependencies):
                return True
        return False

    def _get_depending_variables(self, variable: str) -> Set[str]:
        """
        Returns set of variables, that are actually depending on given variable - in one and only one level.
        For example:
        a <= b, c
        f <= d, c
        c <= z, k

        _get_depending_variables(c) == {a, f}

        :param variable: variable name to get known depending vars on it
        :return: set of depending vars
        """
        return {name for name, definition in self.variables.items() if variable in definition[2]}
