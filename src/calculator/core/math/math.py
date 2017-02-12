# coding=utf-8
import operator

from calculator.exceptions import MathError


class Math(object):
    """
    Core Math class for computing operands by operations to determined result.
    """

    add = operator.add
    subtract = operator.sub
    multiple = operator.mul

    @staticmethod
    def divide(a, b):
        try:
            return operator.truediv(a, b)
        except ZeroDivisionError as e:
            raise MathError from e
