# coding=utf-8
import ast
from _ast import AST


class Parser(object):
    """
    Class, that takes mathematical (python) expression and parses it to Abstract Python Tree with some tweaks:
    # TODO describe tweaks of parser

    """

    def parse(self, expression: str) -> AST:
        tree = ast.parse(
            source=expression,
            mode='eval'
        )
        return tree
