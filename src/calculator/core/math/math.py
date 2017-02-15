# coding=utf-8
import operator
import math

from calculator.exceptions import MathError
from random import random


class Math(object):
    """
    Core Math class for computing operands by operations to determined result.
    """

    add = operator.add
    subtract = operator.sub
    multiple = operator.mul
    abs = math.fabs
    log = math.log  # TODO choosing more accurate functions
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
        return random()
