# coding=utf-8
from unittest.case import TestCase

from calculator.utils.formatter import Formatter


class TestNumberFormatter(TestCase):
    def setUp(self):
        self.formatter = Formatter()

    def test_simple(self):
        self.skipTest('Formatted number in HTML cannot be actually tested.')
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
                self.formatter.format_number(value=value),
                formatted,
                'Formatted value.'
            )
