# coding=utf-8
from unittest import TestCase

from calculator.core.solver import Solver


class SolverInvalidTest(TestCase):
    def setUp(self):
        self.solver = Solver()

        # TODO test of invalids inputs for solver (unsupported operations/constructs)
