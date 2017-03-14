# coding=utf-8
from ast import NodeTransformer, expr, Num
from typing import Optional

from calculator.exceptions import SyntaxRestrictError


class ComplexRestrictTransform(NodeTransformer):
    """
    Restrict for all occurrences of complex numbers in AST tree.
    """

    def visit_Num(self, num: Num) -> Num:
        """
        :param num: Name node of found number in processed AST
        :return: Num node, if variable id can be converted to Num
        """
        if isinstance(num.n, complex):
            raise SyntaxRestrictError('Complex number is not supported.')
        return num
