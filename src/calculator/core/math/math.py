# coding=utf-8
import math
import operator
import random

from calculator._typing import BinaryNumericFunction
from calculator._typing import NumericValue
from calculator.exceptions import MathError


class Math(object):
    """
    Core Math class for computing operands by operations to determined result.
    """

    add = operator.add  # type: BinaryNumericFunction
    subtract = operator.sub  # type: BinaryNumericFunction
    multiple = operator.mul  # type: BinaryNumericFunction

    @staticmethod
    def abs(x: NumericValue) -> NumericValue:
        return math.fabs(x)

    @staticmethod
    def pow(x: NumericValue, y: NumericValue) -> NumericValue:
        return math.pow(x, y)

    @staticmethod
    def divide(a: NumericValue, b: NumericValue) -> NumericValue:
        try:
            return operator.truediv(a, b)
        except ZeroDivisionError as e:
            raise MathError from e

    @staticmethod
    def floor_divide(a: NumericValue, b: NumericValue) -> NumericValue:
        try:
            return operator.floordiv(a, b)
        except ZeroDivisionError as e:
            raise MathError from e

    @staticmethod
    def modulo(a: NumericValue, b: NumericValue) -> NumericValue:
        try:
            return operator.mod(a, b)
        except ZeroDivisionError as e:
            raise MathError from e

    @staticmethod
    def fact(n: NumericValue) -> NumericValue:
        if abs(int(n) - n) > 0:
            raise MathError('Invalid parameter for factorial.')

        try:
            return math.gamma(n + 1)
        except ValueError as e:
            raise MathError from e

    @staticmethod
    def log(x: NumericValue, base: NumericValue = 10) -> NumericValue:
        try:
            return math.log(x, base)
        except ValueError as e:
            raise MathError from e

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

    @classmethod
    def ln(cls, x: NumericValue) -> NumericValue:
        return cls.log(x, math.e)
