# coding=utf-8
import math
from unittest import TestCase
from unittest.mock import patch

from calculator.core.math.math import Math
from calculator.exceptions import MathError

__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class MathTest(TestCase):
    def setUp(self):
        self.math = Math()

    def test_add(self):
        self.assertEqual(
            self.math.add(2, 10),
            12,
            'Simple adding.'
        )

    def test_subtract(self):
        self.assertEqual(
            self.math.subtract(2, 10),
            -8,
            'Simple subtract.'
        )

    def test_multiple(self):
        self.assertEqual(
            self.math.multiple(2, 10),
            20,
            'Simple multiple.'
        )

    def test_divide(self):
        self.assertAlmostEqual(
            self.math.divide(2, 10),
            0.2,
            'Simple divide.'
        )
        with self.assertRaises(MathError):
            self.math.divide(2, 0)

    def test_rand(self):
        values = (0.1, 0.4, 0.6)
        with patch('random.random', side_effect=values):
            for mocked_value in values:
                self.assertEqual(
                    self.math.rand(),
                    mocked_value,
                    'Random values should be equal to mocked.'
                )

    def test_ln(self):
        self.assertEqual(
            self.math.ln(math.e),
            1,
            'Natural log of e should be equal to 1.'
        )
        self.assertEqual(
            self.math.ln(math.e ** 2),
            2,
            'Natural log of powered e should be equal to exponent.'
        )

    def test_log(self):
        self.assertEqual(
            self.math.log(100),
            2,
            'Log of 100 of default base 10 should be equal to 2.'
        )
        self.assertEqual(
            self.math.log(16, 2),
            4,
            'Log of 16 of default base 2 should be equal to 4.'
        )

    def test_invalid_logarithm(self):
        with self.assertRaises(MathError, msg='Invalid value for logarithm.'):
            self.math.log(0)
        with self.assertRaises(MathError, msg='Invalid value for logarithm.'):
            self.math.log(-5)

    def test_fact(self):
        self.assertEqual(
            self.math.fact(3),
            6,
            'Factorial of 3'
        )
        self.assertEqual(
            self.math.fact(170),
            7.257415615307998e+306,
            'Maximum defined factorial'
        )
        with self.assertRaises(MathError, msg='Invalid factorial of -5.'):
            self.math.fact(-5)

        with self.assertRaises(MathError, msg='Invalid factorial of 0.25.'):
            self.math.fact(0.25)

        with self.assertRaises(MathError, msg='Invalid factorial of 5.25.'):
            self.math.fact(5.25)

    def test_root(self):
        self.assertEqual(
            self.math.root(16, 4),
            2,
            'Fourth root from 16 is 4.'
        )
        with self.assertRaises(MathError, msg='Invalid root of -8.'):
            self.math.root(-8)

    def test_floor_div(self):
        self.assertEqual(
            self.math.floor_divide(18, 4),
            4,
            'Floor divided 6 by 4 is 2.'
        )
        self.assertEqual(
            self.math.floor_divide(-3, 4),
            -1,
            'Floor divide.'
        )
        with self.assertRaises(MathError, msg='Invalid floor divide.'):
            self.math.floor_divide(78, 0)

    def test_modulo(self):
        self.assertEqual(
            self.math.modulo(18, 4),
            2,
            'Modulo of positive.'
        )
        self.assertEqual(
            self.math.modulo(-9, 4),
            3,
            'Modulo of negative.'
        )
        with self.assertRaises(MathError, msg='Invalid modulo divider.'):
            self.math.modulo(78, 0)
