# coding=utf-8
from ast import Num, BinOp, AST, UnaryOp, USub, UAdd, Name, Call
from operator import attrgetter
from random import randint
from unittest import TestCase

from calculator.core.solver import Solver


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
            return left_operand * right_operand

        operation = 'operation'

        self.solver.binary_operations = {
            type(operation): op
        }
        self.assertEqual(
            self.solver._resolve(BinOp(left=Num(n=42), op=operation, right=Num(n=98))),
            42 * 98,
            'Bin operation should call the defined operation.'
        )
        self.assertIsNotNone(left, 'Left operand should be given.')
        self.assertIsNotNone(right, 'Right operand should be given.')

    def test_unknown_bin_operation(self):
        self.solver.binary_operations = {}

        with self.assertRaises(NotImplementedError, msg='Not implemented error for unknown bin operation.'):
            self.solver._resolve(BinOp(left=None, op=42, right=None))

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
                    args=args_to_call
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

    def test_resolve_unknown_node(self):
        class Unknown(AST):
            pass

        with self.assertRaises(NotImplementedError, msg='Not implemented error for unknown ast node.'):
            self.solver._resolve(Unknown())
