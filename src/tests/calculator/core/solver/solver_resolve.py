# coding=utf-8
from ast import Num, BinOp, AST
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

        self.solver.bin_operations_table = {
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
        self.solver.bin_operations_table = {}

        with self.assertRaises(NotImplementedError, msg='Not implemented error for unknown bin operation.'):
            self.solver._resolve(BinOp(left=None, op=42, right=None))

    def test_unknown_node(self):
        class UnknownNode(AST):
            pass

        with self.assertRaises(NotImplementedError, msg='Not implemented error for unknown ast node.'):
            self.solver._resolve(UnknownNode())
