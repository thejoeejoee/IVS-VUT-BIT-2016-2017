# coding=utf-8
import re
from ast import NodeTransformer, expr, Num, Name
from typing import Optional, Union


class HexadecimalTransform(NodeTransformer):
    """
    Transforms all hexadecimal convertible Name nodes to directly Num node value.
    """

    HEXADECIMAL_REGEX = re.compile('^(0x|0X)?[A-F0-9]+$')

    def visit_Name(self, node: Name) -> Union[Name, Num]:
        """
        :param node: Name node of found variable in processed AST
        :return: Num node, if variable id can be converted to Num
        """
        if self.HEXADECIMAL_REGEX.fullmatch(node.id):
            return Num(n=int(x=node.id, base=16))
        return node
