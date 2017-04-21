# coding=utf-8
from unittest import TestCase

from calculator.core.parser.preprocessor.absolute_value import AbsoluteValuePreprocessor
from calculator.settings import BuiltinFunction
 
__author__ = "Josef Kolář, Robert Navrátil"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class AbsoluteValuePreprocessorTest(TestCase):
    def setUp(self):
        self.preprocessor = AbsoluteValuePreprocessor()

    def test_single_number(self):
        self.assertEqual(
            self._format_absolute_value('-5'),
            self.preprocessor('|-5|'),
            'Absolute value from single number.'
        )

    def test_simple_expression(self):
        self.assertEqual(
            self._format_absolute_value('2 - z'),
            self.preprocessor('|2 - z|'),
            'Absolute value from simple expression.'
        )

    def test_doubled(self):
        self.assertEqual(
            self._format_absolute_value(self._format_absolute_value('-6')),
            self.preprocessor('||-6||'),
            'Absolute value from simple expression.'
        )

    def test_complex_expression(self):
        self.assertEqual(
            self._format_absolute_value('2 - x', '2 + ', ' * 5'),
            self.preprocessor('2 + |2 - x| * 5'),
            'Absolute value in complex expression.'
        )

    def test_nested_expressions(self):
        self.assertEqual(
            self._format_absolute_value(self._format_absolute_value('x - z', '9 - ', ' / 2'), '2 * ', ' - 8'),
            self.preprocessor('2 * |9 - |x - z| / 2| - 8'),
            'Nested absolute value in complex expression.'
        )

    def test_multiple_nested(self):
        self.assertEqual(
            self._format_absolute_value(
                self._format_absolute_value(
                    'x',
                    self._format_absolute_value('y') + ' + ',
                    ' + ' + self._format_absolute_value('y'),
                ),
                '4 * ',
                ' + z',
            ),
            self.preprocessor('4 * ||y| + |x| + |y|| + z'),
            'Multiple nested absolute values.'
        )

    def test_wrong_brackets_composition(self):
        self.skipTest('Wrong brackets composition isn\'t actually restricted.')
        with self.assertRaises(SyntaxError, msg="Wrong brackets composition."):
            self.preprocessor('(|5)+4|')

    @staticmethod
    def _format_absolute_value(expr: str = '', pre: str = '', post: str = '') -> str:
        return '{}{}({}){}'.format(
            pre,
            BuiltinFunction.ABS,
            expr,
            post
        )