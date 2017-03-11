# coding=utf-8
from unittest.case import TestCase

from calculator.core.calculator import Calculator
from calculator.exceptions import VariableError


class CalculatorTest(TestCase):
    _default_variable_definition = (
        Calculator.DEFAULT_VARIABLE_TYPE(),
        str(Calculator.DEFAULT_VARIABLE_TYPE()),
        set()
    )

    def setUp(self):
        self.calculator = Calculator()

    def test_default_ans(self):
        self.assertTupleEqual(
            self.calculator.variables.get(Calculator.ANSWER_VARIABLE_NAME),
            self._default_variable_definition,
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
        result, variables = self.calculator.process('a = 42')
        self.assertIsNone(
            result,
            'Result of assign should be None.'
        )
        self.assertDictEqual(
            variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition,
                'a': (42, '42', set())
            },
            'Between variables should be added a new variable after assign (and Ans should stay same).'
        )

    def test_new_variables_from_expression(self):
        result, variables = self.calculator.process('a = b + c')
        self.assertIsNone(
            result,
            'Result of assign should be None.'
        )
        self.assertDictEqual(
            variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition,
                'a': (Calculator.DEFAULT_VARIABLE_TYPE(), 'b + c', {'b', 'c'}),
                'b': self._default_variable_definition,
                'c': self._default_variable_definition
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
        with self.assertRaises(SyntaxError, msg='No syntax support for multiple assign.'):
            self.calculator.process('a, b = 8, 8')

        with self.assertRaises(SyntaxError, msg='No syntax support for index assign.'):
            self.calculator.process('f[4] = 5')

        with self.assertRaises(VariableError, msg='Self assign is not supported.'):
            self.calculator.process('c = c')

        self.calculator.process('d = 5')
        self.calculator.process('e = d')
        with self.assertRaises(VariableError, msg='Circular reference in variables definition is not supported.'):
            self.calculator.process('d = e')

        self.assertDictEqual(
            self.calculator.variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition,
                'd': (5, '5', set()),
                'e': (5, 'd', set('d'))
            },
            'After circular invalid assign, variables should stay without changes.'
        )

    def test_variable_updating(self):
        self.calculator.process('a = b + 42')
        result, variables = self.calculator.process('b = 2 * 21')

        self.assertIsNone(
            result,
            'Result of assign should be None.'
        )

        self.assertDictEqual(
            variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition,
                'a': (84, 'b + 42', {'b'}),
                'b': (42, '2 * 21', set())
            },
            'Generated variables list after two operations with calculator.'
        )

    def test_ans_in_expr(self):
        self.calculator.process('5*5')
        result, variables = self.calculator.process('9 + Ans')

        self.assertEqual(
            result,
            34,
            'Result of expression with Ans'
        )

        self.assertDictEqual(
            variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: (34, '9 + Ans', {'Ans'})
            },
            'Ans source expression and dependency'
        )