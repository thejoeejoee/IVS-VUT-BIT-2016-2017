# coding=utf-8
from random import randint
from statistics import mean as stats_mean, stdev
from unittest.case import TestCase

from standard_deviation import mean as my_mean, standard_deviation


class StandardDeviationTest(TestCase):
    def test_mean(self):
        values = self.generate_values()
        self.assertEqual(
            my_mean(values),
            stats_mean(values),
            'Mean should be equal to builtin.'
        )

    def test_standard_deviation(self):
        values = self.generate_values()
        self.assertAlmostEqual(
            standard_deviation(values),
            stdev(values),
            msg='Standard deviation should be equal to builtin.'
        )

    @staticmethod
    def generate_values(n=1000):
        return tuple(randint(-n, n) for _ in range(2 * n))
