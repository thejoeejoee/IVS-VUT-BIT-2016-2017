# coding=utf-8
from ast import BinOp, Add, Num, Sub, Div, Mult, Call, AST, UnaryOp, USub
from typing import Union

from calculator.core.math.math import Math
from calculator.core.parser import Parser
from calculator.core.parser.preprocessor import AbsoluteValuePreprocessor
from calculator.core.parser.preprocessor import FactorialPreprocessor
from calculator.utils import method_single_dispatch

NumericResult = Union[float, int]


class Solver(object):
    """
    Class, that solves mathematical expressions given as string.
    """
    binary_operations = {
        Add: Math.add,
        Sub: Math.subtract,
        Div: Math.divide,
        Mult: Math.multiple,
    }

    builtin_functions = {
        FactorialPreprocessor.FACTORIAL_FUNCTION_NAME: Math.fact,
        AbsoluteValuePreprocessor.ABSOLUTE_VALUE_FUNCTION_NAME: Math.abs,
        'log': Math.log,
        'ln': Math.ln,
        'pow': Math.pow,
        'sqrt': Math.root,
        'root': Math.root,
        'rand': Math.rand,
    }

    def __init__(self):
        super(Solver, self).__init__()
        self._parser = Parser()

    parser = property(lambda self: self._parser)

    def compute(self, node_or_expression: Union[str, AST]) -> NumericResult:
        # TODO: is only Union[int, float]? definitely group it into some configuration

        if not isinstance(node_or_expression, AST):
            node_or_expression = self._parser.parse(expression=node_or_expression).value

        return self._resolve(node_or_expression)

    @method_single_dispatch
    def _resolve(self, node: AST):
        """
        Default endpoint for unresolved types of nodes.
        :param node: expression object
        :return: None
        """
        raise NotImplementedError(node)

    @_resolve.register(BinOp)
    def _(self, bin_op: BinOp) -> NumericResult:
        """
        Endpoint for binary operations (in most cases mathematics)
        :param bin_op: BinOp instance (left and right operands with operation)
        :return: result
        """
        left, op, right = bin_op.left, bin_op.op, bin_op.right

        operation = self.binary_operations.get(type(op))
        if not callable(operation):
            raise NotImplementedError(op)

        return operation(self._resolve(left), self._resolve(right))

    @_resolve.register(UnaryOp)
    def _(self, unary_op: UnaryOp) -> NumericResult:
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
    def _(self, call: Call) -> NumericResult:
        """
        Calls function with resolved parameters and returns result
        :param call: Call node
        :return: result of the called function
        """
        # TODO I am not sure, if call.func is always Name node with .id attribute
        function = self.builtin_functions.get(call.func.id)

        if not callable(function):
            raise NotImplementedError(call.func.id)

        return function(*map(self._resolve, call.args))

    @_resolve.register(Num)
    def _(self, num: Num) -> NumericResult:
        """
        Returns resolved numeric value.
        :param num: Num Node
        :return: standard python number values
        """
        return num.n
