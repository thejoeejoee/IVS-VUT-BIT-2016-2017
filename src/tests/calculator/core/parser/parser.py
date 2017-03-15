# coding=utf-8
from ast import Pass
from unittest import TestCase

from calculator.core.parser import Parser
from calculator.exceptions import ParserSyntaxError


class ParserTest(TestCase):
    def setUp(self):
        self.parser = Parser()

    # TODO test for parser, asserts for valid/invalid inputs (by syntax, no semantic)

    def test_letter_at_end_of_number(self):
        with self.assertRaises(ParserSyntaxError, msg='Invalid number literal with letter at end.'):
            self.parser.parse('42x')

    def test_trailing_brackets(self):
        with self.assertRaises(ParserSyntaxError, msg='Invalid expression with trailing bracket at end.'):
            self.parser.parse('1 + 8)')

    def test_missed_next_token(self):
        with self.assertRaises(ParserSyntaxError,
                               msg='Invalid expression with missing next token for binary operation.'):
            self.parser.parse('1 +')

    def test_standalone_operator(self):
        with self.assertRaises(ParserSyntaxError, msg='Invalid expression with binary operation without operands.'):
            self.parser.parse('+')

    def test_duplicated_dot_in_number_literal(self):
        with self.assertRaises(ParserSyntaxError, msg='Invalid number with doubled dot in number.'):
            self.parser.parse('0..1')

    def test_complex_numbers(self):
        with self.assertRaises(ParserSyntaxError, msg='Invalid number with imaginary unit.'):
            self.parser.parse('1+8j')

    def test_empty_expression(self):
        self.assertIsInstance(
            self.parser.parse(''),
            Pass,
            'Empty expr is Pass'
        )
