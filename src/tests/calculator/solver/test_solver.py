# coding=utf-8
from unittest import TestCase

from calculator.core.solver.solver import Solver


class TestSolver(TestCase):
    def setUp(self):
        self.solver = Solver()

    def test_compute_basic(self):
        self.assertEqual(
            self.solver.compute('40 + 2'),
            42,
            'The answer to life the universe and everything.'
        )
