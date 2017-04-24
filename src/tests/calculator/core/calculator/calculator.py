# coding=utf-8
from unittest.case import TestCase

from calculator.core.calculator import Calculator
from calculator.exceptions import VariableError, VariableRemoveRestrictError, VariableNameError

__author__ = "Josef Kolář, Martin Omacht"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class CalculatorTest(TestCase):
    _default_variable_definition = (
        Calculator.DEFAULT_VARIABLE_TYPE(),
        '= {}'.format(str(Calculator.DEFAULT_VARIABLE_TYPE())),
        set()
    )

    def assertDictEqual(self, d1, d2, msg=None):
        return super().assertDictEqual(dict(d1), dict(d2), msg)

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
                'a': (42, 'a = 42', set())
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
                'a': (Calculator.DEFAULT_VARIABLE_TYPE(), 'a = b + c', {'b', 'c'}),
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
                'a': (8, 'a = 8', set()),
                'b': (80, 'b = (2 + a) * a', {'a'})
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
                'd': (5, 'd = 5', set()),
                'e': (5, 'e = d', set('d'))
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
                'a': (84, 'a = b + 42', {'b'}),
                'b': (42, 'b = 2 * 21', set())
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

        result, variables = self.calculator.process('9 + Ans')

        self.assertEqual(
            result,
            43,
            'Result of second expression with Ans'
        )

        self.assertDictEqual(
            variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: (43, '9 + Ans', {'Ans'})
            },
            'Ans source expression and dependency after second compute with Ans'
        )

    def test_remove_variable(self):
        self.calculator.process('a = 5')
        self.calculator.remove_variable('a')
        self.assertDictEqual(
            self.calculator.variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition
            },
            'Removed a not in variables.'
        )

        self.calculator.process('b = c + 42')
        with self.assertRaises(VariableRemoveRestrictError, msg='Error when removing depending variable.'):
            self.calculator.remove_variable('c')
        self.assertDictEqual(
            self.calculator.variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition,
                'b': (42, 'b = c + 42', {'c'}),
                'c': self._default_variable_definition
            },
            'Variables after invalid remove.'
        )

        with self.assertRaises(VariableError, msg='Remove of unknown variable.'):
            self.calculator.remove_variable('x')

    def test_variable_process(self):
        result, variables = self.calculator.process_variable('a', '42')

        self.assertIsNone(result, 'None is result of assign.')

        self.assertDictEqual(
            {
                Calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition,
                'a': (42, 'a = 42', set())
            },
            variables,
            'Variables after variable process.'
        )

    def test_too_long_variable_name(self):
        var_name = 'a' * (self.calculator.MAX_VARIABLE_NAME_LEN + 1)
        msg = 'Error when creating variable with name longer than {}'.format(self.calculator.MAX_VARIABLE_NAME_LEN)
        with self.assertRaises(VariableNameError, msg=msg):
            self.calculator.process("{} = 42".format(var_name))

        self.assertDictEqual(
            self.calculator.variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition
            },
            'No new variables should be created.'
        )

    def test_too_long_variable_name_in_expr(self):
        var_name = 'a' * (self.calculator.MAX_VARIABLE_NAME_LEN + 1)
        msg = 'Error when creating variable with name longer ' \
              'than {} in expression with default value.'.format(self.calculator.MAX_VARIABLE_NAME_LEN)
        with self.assertRaises(VariableNameError, msg=msg):
            self.calculator.process("5 + {}".format(var_name))

        self.assertDictEqual(
            self.calculator.variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition
            },
            'No new variables should be created.'
        )

    def test_assign_with_long_var_in_expr(self):
        var_name = 'a' * (self.calculator.MAX_VARIABLE_NAME_LEN + 1)
        msg = 'Error when creating variable with name longer ' \
              'than {} in assign expression.'.format(self.calculator.MAX_VARIABLE_NAME_LEN)
        with self.assertRaises(VariableNameError, msg=msg):
            self.calculator.process("a = 5 + {}".format(var_name))

        self.assertDictEqual(
            self.calculator.variables,
            {
                Calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition
            },
            'No new variables should be created.'
        )

    def test_variable_with_max_name_len(self):
        var_name = 'a' * self.calculator.MAX_VARIABLE_NAME_LEN
        result, variables = self.calculator.process("{} = 42".format(var_name))

        self.assertIsNone(result, 'None is result of assign.')
        self.assertDictEqual(
            variables,
            {
                self.calculator.ANSWER_VARIABLE_NAME: self._default_variable_definition,
                var_name: (42, "{} = 42".format(var_name), set())
            },
            'New variable {} should be created.'.format(var_name)
        )

    def test_variable_with_max_name_in_expr(self):
        var_name = 'a' * self.calculator.MAX_VARIABLE_NAME_LEN
        result, variables = self.calculator.process("5 + {}".format(var_name))

        self.assertEqual(result, 5, 'Result should be calculated.')
        self.assertDictEqual(
            variables,
            {
                self.calculator.ANSWER_VARIABLE_NAME: (5, '5 + {}'.format(var_name), {var_name}),
                var_name: self._default_variable_definition
            }
        )
