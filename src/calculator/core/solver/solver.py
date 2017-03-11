# coding=utf-8
from ast import BinOp, Add, Num, Sub, Div, Mult, Call, AST, UnaryOp, USub, Name
from typing import Dict, Union, Type, Set, Optional

from calculator.core.math import Math
from calculator.core.parser import Parser
from calculator.core.parser.preprocessor import AbsoluteValuePreprocessor, FactorialPreprocessor
from calculator.typing import BinaryNumericFunction
from calculator.typing import NumericFunction
from calculator.typing import NumericValue
from calculator.typing import Variable
from calculator.utils import method_single_dispatch


class Solver(object):
    """
    Class, that solves mathematical expressions given as string or already parsed into AST.
    """
    binary_operations = {
        Add: Math.add,
        Sub: Math.subtract,
        Div: Math.divide,
        Mult: Math.multiple,
    }  # type: Dict[Type[AST], BinaryNumericFunction]

    builtin_functions = {
        FactorialPreprocessor.FACTORIAL_FUNCTION_NAME: Math.fact,
        AbsoluteValuePreprocessor.ABSOLUTE_VALUE_FUNCTION_NAME: Math.abs,
        'log': Math.log,
        'ln': Math.ln,
        'pow': Math.pow,
        'sqrt': Math.root,
        'root': Math.root,
        'rand': Math.rand,
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
        function = self.builtin_functions.get(call.func.id)

        if not callable(function):
            raise NotImplementedError(call.func.id)

        return function(*map(self._resolve, call.args))

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
        variable_value, _, _ = self._variables.get(name.id)
        self._used_variables.add(name.id)
        return variable_value

    def get_used_variables(self) -> Optional[Set[str]]:
        """
        Return set of variable names used in last compute() call
        :return: Set[str] or None if compute() hasn't been called yet
        """
        return self._used_variables
