# coding=utf-8
from ast import Assign
from typing import Dict, Tuple

from calculator.core.solver.solver import Solver
from calculator.typing import NumericResult, Variable
from calculator.utils import OrderedDefaultDict


class Calculator(object):
    """
    External API for calculator functionality including operating with variables & custom expressions.
    """

    ANSWER_VARIABLE_NAME = 'Ans'
    DEFAULT_VARIABLE_TYPE = int

    def __init__(self):
        super().__init__()

        self.variables = OrderedDefaultDict(
            default_factory=lambda: (0, 0),  # TODO: return (default result, default source expression)
        )  # type: Dict[str, Variable]

        self._solver = Solver()

    def process(self, expression: str) -> Tuple[NumericResult, Dict[str, Variable]]:
        """
        Process mathematical expression with variables support, returning actual result and variables mapping.
        :param expression:
        :return:
        """
        root_node = self._solver.parser.parse(expression=expression)
        if isinstance(root_node, Assign):
            pass  # TODO: resolve assign and create new variable from source expression
            # TODO: syntax restrict for assign like a, b = 1, 2
        else:
            pass  # TODO from known variables resolve via self.solver result of given expression and set to Ans

        return 0, self.variables
