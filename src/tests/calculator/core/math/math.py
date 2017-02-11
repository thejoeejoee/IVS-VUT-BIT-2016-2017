# coding=utf-8
from unittest import TestCase

from calculator.core.math.math import Math


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
        with self.assertRaises(ZeroDivisionError):
            self.math.divide(2, 0)
