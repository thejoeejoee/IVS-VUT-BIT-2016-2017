# coding=utf-8
import math
import operator
import random

from calculator.exceptions import MathError
from calculator.typing import BinaryNumericFunction
from calculator.typing import NumericValue


class Math(object):
    """
    Core Math class for computing operands by operations to determined result.
    """

    add = operator.add  # type: BinaryNumericFunction
    subtract = operator.sub  # type: BinaryNumericFunction
    multiple = operator.mul  # type: BinaryNumericFunction
    abs = math.fabs  # type: BinaryNumericFunction
    pow = math.pow  # type: BinaryNumericFunction

    @staticmethod
    def divide(a: NumericValue, b: NumericValue) -> NumericValue:
        try:
            return operator.truediv(a, b)
        except ZeroDivisionError as e:
            raise MathError from e

    @staticmethod
    def fact(n: int) -> int:
        try:
            return math.factorial(n)
        except ValueError as e:
            raise MathError from e

    @classmethod
    def log(cls, x: NumericValue, base: NumericValue = 10) -> NumericValue:
        return cls.ln(x, base)

    @staticmethod
    def root(x: NumericValue, y: NumericValue = 2) -> NumericValue:
        try:
            if y == 2:
                return math.sqrt(x)
            else:
                return math.pow(x, 1/y)
        except ValueError as e:
            raise MathError from e

    @staticmethod
    def rand() -> NumericValue:
        """
        Return random floating point number in range <0.0, 1.0)
        :return: random float number in range <0.0, 1.0)
        """
        return random.random()

    @staticmethod
    def ln(x: NumericValue, base: NumericValue = math.e) -> NumericValue:
        # TODO choosing more accurate functions
        try:
            return math.log(x, base)
        except ValueError as e:
            raise MathError from e
