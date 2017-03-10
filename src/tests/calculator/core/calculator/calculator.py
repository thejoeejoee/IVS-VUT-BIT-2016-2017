# coding=utf-8
from unittest.case import TestCase

from calculator.core.calculator import Calculator
from calculator.exceptions import VariableError


class CalculatorTest(TestCase):
    def setUp(self):
        self.calculator = Calculator()

    def test_default_ans(self):
        self.assertTupleEqual(
            self.calculator.variables.get(Calculator.ANSWER_VARIABLE_NAME),
            (Calculator.DEFAULT_VARIABLE_TYPE(), str(Calculator.DEFAULT_VARIABLE_TYPE()), set()),
            'Default answer is 0 from source "0" with no dependencies.'
        )

    def test_simple_calculation(self):
        result, variables = self.calculator.process('1 + 2')
        self.assertEqual(
            1 + 2,
            result,
            'Result of simple calculation.'
        )
        self.assertDictEqual(
            variables,
            {Calculator.ANSWER_VARIABLE_NAME: (result, '1 + 2', set())},
            'Answer variable in variables mapping.'
        )

    def test_variable_assign(self):
        answer_result, answer_expression, answer_dependencies = self.calculator.variables.get(Calculator.ANSWER_VARIABLE_NAME)
        result, variables = self.calculator.process('a = 42')
        self.assertIsNone(
            result,
            'Result of assign should be None.'
        )
        self.assertDictEqual(
            variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: (answer_result, answer_expression, answer_dependencies),
                'a': (42, '42', set())
            },
            'Between variables should be added a new variable after assign (and Ans should stay same).'
        )

    def test_new_variables_from_expression(self):
        answer_result, answer_expression, answer_dependencies = self.calculator.variables.get(Calculator.ANSWER_VARIABLE_NAME)
        result, variables = self.calculator.process('a = b + c')
        self.assertIsNone(
            result,
            'Result of assign should be None.'
        )
        self.assertDictEqual(
            variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: (answer_result, answer_expression, set()),
                'a': (Calculator.DEFAULT_VARIABLE_TYPE(), 'b + c', {'b', 'c'}),
                'b': (Calculator.DEFAULT_VARIABLE_TYPE(), str(Calculator.DEFAULT_VARIABLE_TYPE()), set()),
                'c': (Calculator.DEFAULT_VARIABLE_TYPE(), str(Calculator.DEFAULT_VARIABLE_TYPE()), set())
            },
            'New variable from another two variables.'
        )

    def test_expression_from_existing_variables(self):
        self.calculator.process('a = 8')
        self.calculator.process('b = (2 + a) * a')
        result, variables = self.calculator.process('b / a')
        self.assertEqual(
            result,
            10,
            'Result from two combined variables.'
        )
        self.assertDictEqual(
            variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: (10, 'b / a', {'a', 'b'}),
                'a': (8, '8', set()),
                'b': (80, '(2 + a) * a', {'a'})
            },
            'Generated variables list after three operations with calculator.'
        )

    def test_invalid_assign(self):
        with self.assertRaises(SyntaxError, msg='No syntax support for tuple assign.'):
            self.calculator.process('a, b = 8, 8')

        with self.assertRaises(VariableError, msg='Self assign is not supported.'):
            self.calculator.process('c = c')

        self.calculator.process('d = 5')
        self.calculator.process('e = d')
        with self.assertRaises(VariableError, msg='Circular reference in variables definition is not supported.'):
            self.calculator.process('d = e')

        self.assertDictEqual(
            self.calculator.variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: (
                    Calculator.DEFAULT_VARIABLE_TYPE(), str(Calculator.DEFAULT_VARIABLE_TYPE()), set()
                ),
                'd': (5, '5', set()),
                'e': (5, 'd', set('d'))
            },
            'After circular invalid assign, variables should stay without changes.'
        )
