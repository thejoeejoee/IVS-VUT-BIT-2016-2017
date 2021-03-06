# coding=utf-8
from unittest import TestCase

from calculator.core.solver import Solver

__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class SolverBasicTest(TestCase):
    def setUp(self):
        self.solver = Solver()

    def test_basic_add(self):
        self.assertEqual(
            self.solver.compute('40 + 2'),
            42,
            'The answer to life the universe and everything (and numbers adding).'
        )

    def test_basic_subtract(self):
        self.assertEqual(
            self.solver.compute('40 - 2'),
            38,
            'Subtracting two positive numbers.'
        )

    def test_basic_multiply(self):
        self.assertEqual(
            self.solver.compute('2 * 8'),
            16,
            'Multiplying two positive numbers.'
        )

    def test_basic_divide(self):
        self.assertEqual(
            self.solver.compute('9 / 3'),
            3,
            'Integer division two positive non-zero numbers.'
        )

    def test_bracketed_add(self):
        self.assertEqual(
            self.solver.compute('40 + (2 + 0)'),
            42,
            'Adding with inner expression.'
        )

    def test_bracketed_subtract(self):
        self.assertEqual(
            self.solver.compute('40 - (2 + 6)'),
            32,
            'Subtracting of inner expression in brackets.'
        )

    def test_bracketed_multiply(self):
        self.assertEqual(
            self.solver.compute('2 * (8 * 2)'),
            32,
            'Multiplying with inner expression.'
        )

    def test_bracketed_divide(self):
        self.assertEqual(
            self.solver.compute('(9 / 3) / 3'),
            1,
            'Integer division with inner expression.'
        )

    def test_subtract_bracketed_expression(self):
        self.assertEqual(
            self.solver.compute('-(2 + 5)'),
            -7,
            'Minus whole bracketed expression.'
        )

    def test_add_bracketed_expression(self):
        self.assertEqual(
            self.solver.compute('+(2 + 5)'),
            7,
            'Plus whole bracketed expression.'
        )
