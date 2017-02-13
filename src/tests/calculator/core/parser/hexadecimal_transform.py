# coding=utf-8
from _ast import Name, Num
from unittest import TestCase

from calculator.core.parser.transform.hexadecimal import HexadecimalTransform


class HexadecimalTransformTest(TestCase):
    def setUp(self):
        self.transform = HexadecimalTransform()

    def test_simple_hexadecimal_number(self):
        name = Name(id='A1')
        num = self.transform.visit(name)
        self.assertIsInstance(
            num,
            Num,
            'Transformed hexadecimal literal as Name to Num object.'
        )
        self.assertEqual(
            num.n,
            int('A1', base=16)
        )

    def test_not_modified_variable_name(self):
        name = Name(id='a1')
        transformed_name = self.transform.visit(name)
        self.assertIs(
            transformed_name,
            name,
            'Node variable "a1" node should stay as Name node.'
        )
