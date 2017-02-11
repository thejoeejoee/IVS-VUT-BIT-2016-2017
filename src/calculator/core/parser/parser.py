# coding=utf-8
import ast
from _ast import AST
from typing import Iterable, Sized, Optional

from calculator.core.parser.hexadecimal_transform import HexadecimalTransform


class Parser(object):
    """
    Class, that takes mathematical (python) expression and parses it to Abstract Python Tree with some tweaks:
    # TODO describe tweaks of parser

    """

    # TODO solve problem with hexadecimals literals like '4A'
    DEFAULT_TRANSFORMS = (
        HexadecimalTransform,
    )

    def __init__(self, transforms: Optional[Iterable] = ()):
        super().__init__()

        self._transforms = ()
        if transforms is None:
            self.transforms = self.DEFAULT_TRANSFORMS
        else:
            self.transforms = transforms

    def parse(self, expression: str) -> AST:
        tree = ast.parse(
            source=expression,
            mode='eval'
        )
        for transform in self._transforms:
            tree = transform(tree)

        return tree

    def set_transforms(self, transforms: Sized):
        """
        Sets node transforms for process AST before returning.
        New value could be iterable of:
        1. NodeTransformer subclasses, will be instantiated and used with .visit method
        2. NodeTransformer instances, will by used the .visit method
        3. callable object, directly the item will be used
        4. otherwise AssertionError raised
        :param transforms: Iterable of items described above
        """
        assert isinstance(transforms, Iterable)
        self._transforms = tuple(filter(
            None,
            ((
                 transform().visit  # given as class, so instantiated and get the .visit
                 if isinstance(transform, type) and issubclass(transform, ast.NodeTransformer)
                 else transform.visit  # given and transform object, directly get the .visit
                 if isinstance(transform, ast.NodeTransformer)
                 else transform  # directly callable
                 if callable(transform)
                 else None  # otherwise filtered by filter(None, ...)
             ) for transform in transforms
             )
        ))
        # TODO: Assertion or TypeError?
        assert len(self._transforms) == len(transforms), 'Unknown transform(s) given.'

    transforms = property(fset=set_transforms)
