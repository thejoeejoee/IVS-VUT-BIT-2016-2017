# coding=utf-8
from ast import BinOp, Add, Num, Sub, Div, Mult, Call, AST, UnaryOp, USub
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

    function_calls_table = {
        'fact': Math.fact,
        'abs': Math.abs,
        'log': Math.log,
        'ln': Math.log,
        'pow': Math.pow,
        'sqrt': Math.root,
        'root': Math.root,
        'rand': Math.rand,
    }

    def __init__(self):
        self._parser = Parser()

    def compute(self, expression: str) -> Union[int, float]:
        # TODO: is only Union[int, float]? definitely group it into some configuration

        tree = self._parser.parse(expression=expression)
        return self._resolve(tree.body)

    @method_single_dispatch
    def _resolve(self, node: AST):
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

    @_resolve.register(UnaryOp)
    def _(self, unary_op: UnaryOp) -> Union[int, float]:
        """
        Endpoint for unary operations.
        :param unary_op: UnaryOp instance (operation and operand)
        :return: result
        """
        op, operand = unary_op.op, unary_op.operand

        if isinstance(op, USub):
            return - self._resolve(operand)
        else:
            return + self._resolve(operand)

    @_resolve.register(Call)
    def _(self, call: Call) -> Union[int, float]:
        """
        Calls function with resolved parameters and returns result
        :param call: Call node
        :return: result of the called function
        """
        # TODO I am not sure, if call.func is always Name node with .id attribute
        function = self.function_calls_table.get(call.func.id)
        if callable(function):
            return function(*map(self._resolve, call.args))
        else:
            raise NotImplementedError(call.func.id)

    @_resolve.register(Num)
    def _(self, num: Num) -> Union[int, float]:
        """
        Returns resolved numeric value.
        :param num: Num Node
        :return: standard python number values
        """
        return num.n
