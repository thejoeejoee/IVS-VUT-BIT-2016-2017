# coding=utf-8
from _ast import BinOp, Add, Num, expr, Sub, Div, Mult
from typing import Union

from calculator.core.math.math import Math
from calculator.core.parser import Parser
from calculator.utils import method_single_dispatch


class Solver(object):
    """
    Class, that solves mathematical expressions given as string.
    """
    bin_operations_table = {
        Add: Math.add,
        Sub: Math.subtract,
        Div: Math.divide,
        Mult: Math.multiple,
    }

    def __init__(self):
        self._parser = Parser()

    def compute(self, expression: str) -> Union[int, float]:
        # TODO: is only Union[int, float]? definitely group it into some configuration

        tree = self._parser.parse(expression=expression)
        return self._resolve(tree.body)

    @method_single_dispatch
    def _resolve(self, node: expr):
        """
        Default endpoint for unresolved types of nodes.
        :param node: expression object
        :return: None
        """
        raise NotImplementedError(node)

    @_resolve.register(BinOp)
    def _(self, bin_op: BinOp) -> Union[int, float]:
        """
        Endpoint for binary operations (in most cases mathematics)
        :param bin_op: BinOp instance (left and right operands with operation)
        :return: result
        """
        left, op, right = bin_op.left, bin_op.op, bin_op.right

        operation = self.bin_operations_table.get(type(op))
        if not callable(operation):
            raise NotImplementedError(op)

        return operation(self._resolve(left), self._resolve(right))

    @_resolve.register(Num)
    def _(self, num: Num) -> Union[int, float]:
        """
        Returns resolved numeric value.
        :param num: Num Node
        :return: standard python number values
        """
        return num.n
