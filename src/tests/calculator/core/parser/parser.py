# coding=utf-8
from unittest import TestCase

from calculator.core.parser import Parser


class ParserTest(TestCase):
    def setUp(self):
        self.parser = Parser()

        # TODO test for parser, asserts for valid/invalid inputs (by syntax, no semantic)
