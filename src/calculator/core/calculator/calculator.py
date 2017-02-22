# coding=utf-8
from ast import Assign, Name
from typing import Dict, Tuple

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
            default_factory=lambda: (0, 0),  # TODO: return (default result, default source expression)
        )  # type: Dict[str, Variable]

        self._solver = Solver()

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
            # TODO: syntax restrict for assign like a, b = 1, 2
            if len(root_node.targets) is not 1 or not isinstance(root_node.targets[0], Name):
                raise VariableError()

            value = self._solver.compute(root_node.value)
            self._variables[root_node.targets[0].id] = value
        else:
            pass  # TODO from known variables resolve via self.solver result of given expression and set to Ans

        return 0, self._variables
