# coding=utf-8
import ast


class Parser(object):
    """
    Class, that takes mathematical (python) expression and parses it to Abstract Python Tree.
    """

    def parse(self, expression: str):
        tree = ast.parse(
            source=expression,
            mode='eval'
        )
        return tree
