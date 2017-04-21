# coding=utf-8
from ast import AugAssign, NodeTransformer

from calculator.exceptions import SyntaxRestrictError

__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class AugAssignRestrictTransform(NodeTransformer):
    """
    Restrict for aug assignments like a += 5.
    """

    def visit_AugAssign(self, assign: AugAssign) -> None:
        """
        :param assign: AugAssign node of found assign in processed AST
        """
        raise SyntaxRestrictError('Aug assign is not actually supported.')
