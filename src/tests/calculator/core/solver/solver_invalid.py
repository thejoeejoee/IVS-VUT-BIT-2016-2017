# coding=utf-8
from unittest import TestCase

from calculator.core.solver import Solver
from calculator.exceptions import MathError

__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class SolverInvalidTest(TestCase):
    def setUp(self):
        self.solver = Solver()

        # TODO test of invalids inputs for solver (unsupported operations/constructs)

    def test_zero_division(self):
        with self.assertRaises(MathError, msg='Divide with 0 should raise math error.'):
            self.solver.compute('42 / 0')
