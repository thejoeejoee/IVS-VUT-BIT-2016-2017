# coding=utf-8
from _ast import Name, Num
from unittest import TestCase

from calculator.core.parser.hexadecimal_transform import HexadecimalTransform


class TestHexadecimalTransform(TestCase):
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
