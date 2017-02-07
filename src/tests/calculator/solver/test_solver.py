# coding=utf-8
from unittest import TestCase

from calculator.core.solver import Solver


class TestSolver(TestCase):
    def setUp(self):
        self.solver = Solver()

    def test_compute_basic_expressions(self):
        self.assertEqual(
            self.solver.compute('40 + 2'),
            42,
            'The answer to life the universe and everything (and numbers adding).'
        )
        self.assertEqual(
            self.solver.compute('40 - 2'),
            38,
            'Subtracting two positive numbers.'
        )
        self.assertEqual(
            self.solver.compute('2 * 8'),
            16,
            'Multiplying two positive numbers.'
        )
        self.assertEqual(
            self.solver.compute('9 / 3'),
            3,
            'Integer division two positive non-zero numbers.'
        )

    def test_compute_bracketed_expressions(self):
        self.assertEqual(
            self.solver.compute('40 + (2 + 0)'),
            42,
            'Adding with inner expression.'
        )
        self.assertEqual(
            self.solver.compute('40 - (2 + 6)'),
            32,
            'Subtracting of inner expression in brackets.'
        )
        self.assertEqual(
            self.solver.compute('2 * (8 * 2)'),
            32,
            'Multiplying with inner expression.'
        )
        self.assertEqual(
            self.solver.compute('(9 / 3) / 3'),
            1,
            'Integer division with inner expression.'
        )
