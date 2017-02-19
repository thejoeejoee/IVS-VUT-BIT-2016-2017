# coding=utf-8
from ast import Num
from unittest import TestCase

from calculator.core.parser.transform.complex_restrict import ComplexRestrictTransform


class ComplexRestrictTransformTest(TestCase):
    def setUp(self):
        self.transform = ComplexRestrictTransform()

    def test_restrict_complex_number(self):
        with self.assertRaises(SyntaxError):
            self.transform.visit(
                Num(n=complex(1, 1))
            )

    def test_no_restrict_real_numbers(self):
        try:
            self.transform.visit(
                Num(n=int(42))
            )
        except SyntaxError as e:
            self.fail(str(e))
