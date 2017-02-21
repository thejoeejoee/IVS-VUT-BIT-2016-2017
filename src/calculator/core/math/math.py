# coding=utf-8
import math
import operator
import random

from calculator.exceptions import MathError


class Math(object):
    """
    Core Math class for computing operands by operations to determined result.
    """

    add = operator.add
    subtract = operator.sub
    multiple = operator.mul
    abs = math.fabs
    pow = math.pow

    @staticmethod
    def divide(a, b):
        try:
            return operator.truediv(a, b)
        except ZeroDivisionError as e:
            raise MathError from e

    @staticmethod
    def fact(n):
        try:
            return math.factorial(n)
        except ValueError as e:
            raise MathError from e

    @classmethod
    def log(cls, x, base=10):
        return cls.ln(x, base)

    @staticmethod
    def root(x, y=2):
        try:
            if y == 2:
                return math.sqrt(x)
            else:
                return math.pow(x, 1/y)
        except ValueError as e:
            raise MathError from e

    @staticmethod
    def rand():
        """
        Return random floating point number in range <0.0, 1.0)
        :return: random float number in range <0.0, 1.0)
        """
        return random.random()

    @staticmethod
    def ln(x, base=math.e):
        # TODO choosing more accurate functions
        try:
            return math.log(x, base)
        except ValueError as e:
            raise MathError from e
