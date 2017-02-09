# coding=utf-8
from ast import NodeTransformer, copy_location


class HexadecimalTransform(NodeTransformer):
    """
    Transforms all hexadecimal convertible Name nodes to directly Num node value.

    """
    def visit_Name(self, node):
        """
        Subscript(
            value=Name(id='data', ctx=Load()),
            slice=Index(value=Str(s=node.id)),
            ctx=node.ctx
        )
        :param node:
        :return:
        """
        # TODO: if node.id van be convert to int, use the Num Node
        return node
