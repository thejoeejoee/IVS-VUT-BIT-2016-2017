# coding=utf-8
from unittest import TestCase

from calculator.core.parser.preprocessor.factorial import FactorialPreprocessor


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

    @staticmethod
    def _format_factorial(expr='', pre='', post=''):
        return '{}{}({}){}'.format(
            pre,
            FactorialPreprocessor.FACTORIAL_FUNCTION_NAME,
            expr,
            post
        )
