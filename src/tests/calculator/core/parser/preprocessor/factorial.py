# coding=utf-8
from unittest import TestCase

from calculator.core.parser.preprocessor.factorial import FactorialPreprocessor
from calculator.settings import BuiltinFunction

__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class FactorialPreprocessorTest(TestCase):
    def setUp(self):
        self.preprocessor = FactorialPreprocessor()

    def test_simple_number(self):
        self.assertEqual(
            self._format_factorial('25'),
            self.preprocessor('25!'),
            'Simple factorial of single number.'
        )

    def test_doubled(self):
        self.assertEqual(
            self._format_factorial(self._format_factorial('6')),
            self.preprocessor('6!!'),
            'Doubled factorial of single number.'
        )

    def test_number_in_operation(self):
        self.assertEqual(
            self._format_factorial('5', '(1 + 5) + ', ' + 8'),
            self.preprocessor('(1 + 5) + 5! + 8'),
            'Factorial used as operand in complex operation.'
        )

    def test_simple_brackets(self):
        self.assertEqual(
            self._format_factorial('1 + 2'),
            self.preprocessor('(1 + 2)!'),
            'Factorial of whole brackets.'
        )

    def test_brackets_in_operation(self):
        self.assertEqual(
            self._format_factorial('1 + 2', '2 + ', ' + 9'),
            self.preprocessor('2 + (1 + 2)! + 9'),
            'Factorial for brackets used in operation.'
        )

    def test_nested_simple(self):
        self.assertEqual(
            self._format_factorial(self._format_factorial('2', '1 + ')),
            self.preprocessor('(1 + 2!)!'),
            'Test for simple nested factorial.'
        )

    def test_nested_complex(self):
        self.assertEqual(
            self._format_factorial(self._format_factorial('2 + 3', '1 + ', ' + 5')),
            self.preprocessor('(1 + (2 + 3)! + 5)!'),
            'Test for complex nested factorial.'
        )

    def test_factorized_function(self):
        self.skipTest('Factorial of function call of factorized parameter is not actually supported.')
        self.assertEqual(
            self._format_factorial(self._format_factorial('5', 'abs(', ')')),
            self.preprocessor('abs(5!)!'),
            'Test for factorized of result from function call.'
        )

    def test_variable_factorial(self):
        self.assertEqual(
            self._format_factorial('foobar'),
            self.preprocessor('foobar!'),
            'Test for factorized foo variable call.'
        )

    def test_advanced_variable_factorial(self):
        self.assertEqual(
            self._format_factorial('foobar56 + bar5'),
            self.preprocessor('(foobar56 + bar5)!'),
            'Test for factorized foo variable call.'
        )

    @staticmethod
    def _format_factorial(expr: str = '', pre: str = '', post: str = '') -> str:
        return '{}{}({}){}'.format(
            pre,
            BuiltinFunction.FACT,
            expr,
            post
        )
