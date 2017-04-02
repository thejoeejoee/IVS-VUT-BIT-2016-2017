# coding=utf-8
from ast import AugAssign, NodeTransformer

from calculator.exceptions import SyntaxRestrictError


class AugAssignRestrictTransform(NodeTransformer):
    """
    Restrict for aug assignments like a += 5.
    """

    def visit_AugAssign(self, assign: AugAssign) -> None:
        """
        :param assign: AugAssign node of found assign in processed AST
        """
        raise SyntaxRestrictError('Aug assign is not actually supported.')
