# coding=utf-8
from ast import BinOp, Add, Num, Sub, Div, Mult, Call, AST, UnaryOp, USub, Name, Pow, FloorDiv, Mod
from inspect import Signature
from operator import attrgetter
from typing import Dict, Union, Type, Set, Optional

from calculator import BinaryNumericFunction, NumericFunction, NumericValue, Variable
from calculator.core.math import Math
from calculator.core.parser import Parser
from calculator.exceptions import InvalidFunctionCallError
from calculator.settings import BuiltinFunction
from calculator.utils import method_single_dispatch

__author__ = "Josef Kolář, Martin Omacht"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class Solver(object):
    """
    Class, that solves mathematical expressions given as string or already parsed into AST.
    """
    binary_operations = {
        Add: Math.add,
        Sub: Math.subtract,
        Div: Math.divide,
        Mult: Math.multiple,
        Pow: Math.pow,
        FloorDiv: Math.floor_divide,
        Mod: Math.modulo,
    }  # type: Dict[Type[AST], BinaryNumericFunction]

    builtin_functions = {
        BuiltinFunction.FACT: Math.fact,
        BuiltinFunction.ABS: Math.abs,
        BuiltinFunction.LOG: Math.log,
        BuiltinFunction.LN: Math.ln,
        BuiltinFunction.POW: Math.pow,
        BuiltinFunction.ROOT: Math.root,
        BuiltinFunction.SQRT: Math.root,
        BuiltinFunction.RAND: Math.rand,
    }  # type: Dict[str, NumericFunction]

    _variables = None  # type: Dict[str, Variable]
    _used_variables = None  # type: Set[str]

    def __init__(self):
        super(Solver, self).__init__()
        self._parser = Parser()

    parser = property(lambda self: self._parser)
    variables = property(lambda self: self._variables)

    def compute(
            self,
            node_or_expression: Union[str, AST],
            variables: Optional[Dict[str, Variable]] = None
    ) -> NumericValue:
        """
        Computes result of math expression given as string or AST tree into numeric result.
        :param node_or_expression:
        :param variables: known variables
        :return:
        """
        # If assign is invalid, we don't want to change variables in Calculator
        self._variables = variables.copy() if variables else {}
        self._used_variables = set()
        if not isinstance(node_or_expression, AST):
            node_or_expression = self._parser.parse(expression=node_or_expression).value

        return self._resolve(node_or_expression)

    @method_single_dispatch
    def _resolve(self, node: AST) -> NumericValue:
        """
        Default endpoint for unresolved types of nodes.
        :param node: expression object
        :return: None
        """
        raise NotImplementedError(node)

    @_resolve.register(BinOp)
    def _(self, bin_op: BinOp) -> NumericValue:
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
    def _(self, unary_op: UnaryOp) -> NumericValue:
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
    def _(self, call: Call) -> NumericValue:
        """
        Calls function with resolved parameters and returns result
        :param call: Call node
        :return: result of the called function
        """
        # TODO I am not sure, if call.func is always Name node with .id attribute
        function_name = call.func.id
        function = self.builtin_functions.get(function_name)

        if not callable(function):
            raise NameError(function_name)

        signature = Signature.from_callable(function)

        args = tuple(map(self._resolve, call.args))
        kwargs = dict(zip(
            map(attrgetter('arg'), call.keywords),
            map(
                self._resolve,
                map(
                    attrgetter('value'),
                    call.keywords
                )
            )
        ))

        try:
            signature.bind(*args, **kwargs)
        except TypeError as e:
            raise InvalidFunctionCallError(
                function_name,
                'Given parameters does not correspond to function signature.'
            ) from e

        return function(*args, **kwargs)

    @_resolve.register(Num)
    def _(self, num: Num) -> NumericValue:
        """
        Returns resolved numeric value.
        :param num: Num Node
        :return: standard python number values
        """
        return num.n

    @_resolve.register(Name)
    def _(self, name: Name) -> NumericValue:
        """
        Returns value of the variable or creates new with default value
        :param name: Name Node
        :return: standard python number value
        """
        # TODO restriction for reserved variable names
        # If variable does not exists, OrderedDefaultDict creates it with default values
        variable_name = name.id
        variable_value, _, _ = self._variables.get(variable_name)
        self._used_variables.add(variable_name)
        return variable_value

    def get_used_variables(self) -> Optional[Set[str]]:
        """
        Return set of variable names used in last compute() call
        :return: Set[str] or None if compute() hasn't been called yet
        """
        return self._used_variables
