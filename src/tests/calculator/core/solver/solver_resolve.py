# coding=utf-8
from ast import Num, BinOp, AST, UnaryOp, USub, UAdd, Name, Call, keyword
from operator import attrgetter
from random import randint
from unittest import TestCase

from calculator.core.solver import Solver
from calculator.exceptions import InvalidFunctionCallError


class SolverResolveTest(TestCase):
    def setUp(self):
        self.solver = Solver()

    def test_num(self):
        self.assertEqual(
            self.solver._resolve(Num(n=42)),
            42,
            'Num node should be resolved to number value.'
        )

    def test_bin_operation(self):
        left = right = None

        def op(left_operand, right_operand):
            nonlocal left, right
            left = left_operand
            right = right_operand
            return left_operand, right_operand

        operation = 'operation'

        self.solver.binary_operations = {
            type(operation): op
        }
        self.assertEqual(
            self.solver._resolve(BinOp(left=Num(n=42), op=operation, right=Num(n=98))),
            (42, 98),
            'Bin operation should call the defined operation.'
        )
        self.assertIsNotNone(left, 'Left operand should be given.')
        self.assertIsNotNone(right, 'Right operand should be given.')

    def test_unknown_bin_operation(self):
        self.solver.binary_operations = {}

        with self.assertRaises(NotImplementedError, msg='Not implemented error for unknown bin operation.'):
            self.solver._resolve(BinOp(left=None, op=42, right=None))

    def test_default_bin_operations(self):
        for node_type, operation in self.solver.binary_operations.items():
            self.assertEqual(
                self.solver.compute(BinOp(left=Num(n=8), op=node_type(), right=Num(n=10))),
                operation(8, 10)
            )

    def test_unknown_node(self):
        class UnknownNode(AST):
            pass

        with self.assertRaises(NotImplementedError, msg='Not implemented error for unknown ast node.'):
            self.solver._resolve(UnknownNode())

    def test_unary_operation(self):
        self.assertEqual(
            -42,
            self.solver._resolve(UnaryOp(op=USub(), operand=Num(42))),
            'Unary subtract should return negated number value.'
        )
        self.assertEqual(
            42,
            self.solver._resolve(UnaryOp(op=UAdd(), operand=Num(42))),
            'Unary subtract should return negated number value.'
        )

    def test_call_node(self):
        called = False
        called_args = ()

        def function(*args):
            nonlocal called, called_args
            called = True
            called_args = args
            return id(function)

        self.solver.builtin_functions = {
            function.__name__: function
        }
        args_to_call = tuple(Num(n=randint(5, 50)) for _ in range(randint(1, 10)))
        self.assertEqual(
            id(function),
            self.solver._resolve(
                Call(
                    func=Name(
                        id=function.__name__,
                    ),
                    args=args_to_call,
                    keywords=list()
                )
            ),
            'Resolve Call should return same value as mocked function.'
        )
        self.assertTupleEqual(
            tuple(map(attrgetter('n'), args_to_call)),
            called_args,
            'Args given to mocked function should be same as given to _resolve.'
        )
        self.assertTrue(called, 'Function should to be called.')

    def test_invalid_call_node(self):
        called = False

        def function(a, b=42):
            nonlocal called
            called = True
            return a

        self.solver.builtin_functions = {
            function.__name__: function
        }
        with self.assertRaises(InvalidFunctionCallError, msg='Call without required parameter.'):
            self.solver._resolve(
                Call(
                    func=Name(
                        id=function.__name__,
                    ),
                    args=tuple(),
                    keywords=list()
                )
            )
        self.assertFalse(called, 'Function should not to be called after invalid try.')

        with self.assertRaises(InvalidFunctionCallError, msg='Call with too much params.'):
            self.solver._resolve(
                Call(
                    func=Name(
                        id=function.__name__,
                    ),
                    args=(Num(n=4), Num(n=9), Num(n=5)),
                    keywords=list()
                )
            )
        self.assertFalse(called, 'Function should not to be called after invalid try.')

        with self.assertRaises(InvalidFunctionCallError, msg='Call with keyword param.'):
            self.solver._resolve(
                Call(
                    func=Name(
                        id=function.__name__,
                    ),
                    args=(Num(n=9),),
                    keywords=[keyword(arg='e', value=Num(n=9)), ]
                )
            )
        self.assertFalse(called, 'Function should not to be called after invalid try.')

        args_to_call = Num(n=3),
        self.assertEqual(
            3,
            self.solver._resolve(
                Call(
                    func=Name(
                        id=function.__name__,
                    ),
                    args=args_to_call,
                    keywords=[]
                )
            ),
            'Resolve Call should return same value as mocked function.'
        )
        self.assertTrue(called, 'Function should to be called after valid call try.')

    def test_resolve_unknown_node(self):
        class Unknown(AST):
            pass

        with self.assertRaises(NotImplementedError, msg='Not implemented error for unknown ast node.'):
            self.solver._resolve(Unknown())
