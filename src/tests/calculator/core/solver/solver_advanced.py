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

    def test_zero_factorial(self):
        self.assertEqual(
            self.solver.compute('0!'),
            1,
            'Factorial from zero.'
        )

    def test_fraction_factorial(self):
        self.assertAlmostEqual(
            self.solver.compute('0.5!'),
            0.88622692545275801364908374167057,
            'Factorial from fraction'
        )

    def test_expression_with_multiple_nested_brackets(self):
        self.assertAlmostEqual(
            self.solver.compute('(2 + 1) * ((20 + 1) * 3)'),
            (2 + 1) * ((20 + 1) * 3),
            'Expression with multiple nested brackets.'
        )
