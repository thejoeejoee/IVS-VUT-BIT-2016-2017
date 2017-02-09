# coding=utf-8
import re
from _ast import Num
from ast import NodeTransformer, expr
from typing import Optional


class HexadecimalTransform(NodeTransformer):
    """
    Transforms all hexadecimal convertible Name nodes to directly Num node value.

    """

    HEXADECIMAL_REGEX = re.compile('^(0x|0X)?[A-F0-9]+$')

    def visit_Name(self, node: expr) -> Optional[expr]:
        """
        Subscript(
            value=Name(id='data', ctx=Load()),
            slice=Index(value=Str(s=node.id)),
            ctx=node.ctx
        )
        :param node:
        :return:
        """
        if self.HEXADECIMAL_REGEX.fullmatch(node.id):
            return Num(n=int(x=node.id, base=16))
        return node
