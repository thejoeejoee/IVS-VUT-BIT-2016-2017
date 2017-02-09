# coding=utf-8
from unittest import TestCase

from calculator.core.parser import Parser
from calculator.exceptions import ParserSyntaxError


class ParserTest(TestCase):
    def setUp(self):
        self.parser = Parser()

        # TODO test for parser, asserts for valid/invalid inputs (by syntax, no semantic)

    def test_invalid_number_literal(self):
        with self.assertRaises(ParserSyntaxError):
            self.parser.parse('42x')
