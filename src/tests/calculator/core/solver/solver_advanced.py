# coding=utf-8
from unittest import TestCase

from calculator.core.solver import Solver


class SolverAdvancedTest(TestCase):
    def setUp(self):
        self.solver = Solver()

    def test_factorial(self):
        self.assertEqual(
            self.solver.compute('7!'),
            5040,
            'Simple factorial.'
        )

    def test_factorial_in_operation(self):
        self.assertEqual(
            self.solver.compute('7! + 5'),
            5045,
            'Factorial in operation.'
        )
        self.assertEqual(
            self.solver.compute('5 + 7!'),
            5045,
            'Factorial in operation.'
        )

    def test_factorial_of_whole_bracket(self):
        self.assertEqual(
            self.solver.compute('3 + (2 + 1)! + 5'),
            14,
            'Factorial of whole bracket.'
        )

    def test_zero_factorial(self):
        self.assertEqual(
            self.solver.compute('0!'),
            1,
            'Factorial from zero.'
        )

    def test_expression_with_multiple_nested_brackets(self):
        self.assertAlmostEqual(
            self.solver.compute('(2 + 1) * ((20 + 1) * 3)'),
            (2 + 1) * ((20 + 1) * 3),
            'Expression with multiple nested brackets.'
        )

    def test_factorial_of_absolute_value(self):
        self.assertAlmostEqual(
            self.solver.compute('|1 + 2|!'),
            6,
            'Expression factorial of absolute value.'
        )

    def test_absolute_value_of_factorial(self):
        self.assertAlmostEqual(
            self.solver.compute('-|3!|'),
            -6,
            'Expression of absolute value from factorial.'
        )
