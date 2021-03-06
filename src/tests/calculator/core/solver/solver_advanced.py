# coding=utf-8
from unittest import TestCase

from calculator.core.solver import Solver

__author__ = "Josef Kolář, Martin Omacht"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


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
            self.solver.compute('-|3! - 1!|'),
            -5,
            'Expression of absolute value from factorial.'
        )

    def test_floor_division(self):
        self.assertEqual(
            self.solver.compute('5 // 3'),
            1,
            'Floor division of standard numbers'
        )

    def test_floor_negative_division(self):
        self.assertEqual(
            self.solver.compute('-5 // 3'),
            -2,
            'Floor division with negative number'
        )

    def test_modulo(self):
        self.assertEqual(
            self.solver.compute('5 % 3'),
            2,
            'Modulo of with standard numbers'
        )

    def test_negative_modulo(self):
        self.assertEqual(
            self.solver.compute('-5 % 3'),
            1,
            'Modulo with negative number'
        )
