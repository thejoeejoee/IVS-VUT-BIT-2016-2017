# coding=utf-8
from unittest.case import TestCase

from calculator.utils.number_formatter import NumberFormatter


class TestNumberFormatter(TestCase):
    def setUp(self):
        self.formatter = NumberFormatter()

    def test_simple(self):
        cases = (
            (2, '2'),
            (2.35, '2.35'),
            (1. / 3, '0.333333'),
            (10 ** 100, '1.00e+100'),
            (0.123456789, '0.123456'),
            (123456789.123456789, '1.23e+8')
        )
        for value, formatted in cases:
            self.assertEqual(
                self.formatter.format(value=value),
                formatted,
                'Formatted value.'
            )
