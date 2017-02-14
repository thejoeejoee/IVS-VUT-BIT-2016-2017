# coding=utf-8
import re
from _ast import Num
from ast import NodeTransformer, expr
from typing import Optional


class ComplexRestrictTransform(NodeTransformer):
    """
    Restrict for all occurrences of complex numbers in AST tree.
    """

    def visit_Num(self, num: Num) -> Optional[expr]:
        """
        :param num: Name node of found number in processed AST
        :return: Num node, if variable id can be converted to Num
        """
        if isinstance(num.n, complex):
            # TODO some restrict exception?
            raise SyntaxError('Complex number is not supported.')
        return num
