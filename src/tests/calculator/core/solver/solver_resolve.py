# coding=utf-8
from ast import Num, BinOp
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
