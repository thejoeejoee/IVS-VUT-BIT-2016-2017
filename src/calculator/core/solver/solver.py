# coding=utf-8
from ..parser import Parser


class Solver(object):
    """
    Class, that solves mathematical expressions given as string.
    """

    def __init__(self):
        self._parser = Parser()

    def compute(self, expression: str) -> int:
        tree = self._parser.parse(expression=expression)
        return 0
