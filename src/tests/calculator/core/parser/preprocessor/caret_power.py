# coding=utf-8
from unittest import TestCase

from calculator.core.parser.preprocessor.caret_power import CaretPowerPreprocessor
 
__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class CaretPowerPreprocessorTest(TestCase):
    def setUp(self):
        self.preprocessor = CaretPowerPreprocessor()

    def test_simple(self):
        self.assertEqual(
            self.preprocessor('2 ^ 4'),
            '2 ** 4'
        )

    def test_advanced(self):
        self.assertEqual(
            self.preprocessor('(2 ^ 5) ^ 6'),
            '(2 ** 5) ** 6'
        )

    def test_power_unchanged(self):
        self.assertEqual(
            self.preprocessor('2 ** 9'),
            '2 ** 9'
        )