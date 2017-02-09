# coding=utf-8
import ast

from calculator.exceptions import ParserSyntaxError


class Parser(object):
    """
    Class, that takes mathematical (python) expression and parses it to Abstract Python Tree with some tweaks:
    # TODO describe tweaks of parser

    """

    def parse(self, expression: str) -> ast.AST:
        try:
            tree = ast.parse(
                source=expression,
                mode='eval'
            )
        except SyntaxError as e:
            raise ParserSyntaxError() from e
        return tree
