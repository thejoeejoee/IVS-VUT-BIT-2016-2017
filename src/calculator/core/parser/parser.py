# coding=utf-8
from ast import AST, NodeTransformer, parse, Pass
from typing import Iterable, Sized, Optional, Union, Callable, Tuple

from calculator.core.parser.preprocessor import AbsoluteValuePreprocessor
from calculator.core.parser.preprocessor import FactorialPreprocessor
from calculator.core.parser.transform import ComplexRestrictTransform
from calculator.exceptions import ParserSyntaxError, SyntaxRestrictError


class Parser(object):
    """
    Class, that takes mathematical (python) expression and parses it to Abstract Python Tree with some tweaks.
    """

    DEFAULT_PREPROCESSORS = (
        AbsoluteValuePreprocessor,
        FactorialPreprocessor,
    )
    # TODO solve problem with hexadecimals literals like '4A'
    DEFAULT_TRANSFORMS = (
        ComplexRestrictTransform,
    )

    _transforms = ()
    _preprocessors = ()

    def __init__(
            self,
            transforms: Optional[Iterable[Union[Callable, NodeTransformer, type]]] = None,
            preprocessors: Optional[Iterable[Union[Callable, type]]] = None,
    ) -> None:
        """
        :param transforms: optional iterable
        """
        super().__init__()

        self._transforms = ()
        self._preprocessors = ()
        if transforms is None:
            self.transforms = self.DEFAULT_TRANSFORMS
        else:
            self.transforms = transforms
        if preprocessors is None:
            self.preprocessors = self.DEFAULT_PREPROCESSORS
        else:
            self.preprocessors = preprocessors

    def parse(self, expression: str) -> AST:
        """
        Parse given expression to AST.
        Before processing by AST module, expression is normalized, processed by preprocessors.
        Parsed tree is given to all transforms.
        :param expression: math expression as string
        :return: Tree as AST module objects - processable by Solver class
        """
        try:
            for preprocessor in self._preprocessors:
                expression = preprocessor(expression)
        except SyntaxRestrictError as e:
            raise ParserSyntaxError('Restricted syntax') from e

        try:
            body = parse(
                source=expression
            ).body
            if not body:
                return Pass()
            root = body[0]
            for transform in self._transforms:
                root = transform(root)
        except SyntaxError as e:
            raise ParserSyntaxError('Invalid expression syntax') from e
        return root

    def set_transforms(self, transforms: Sized) -> None:
        """
        Sets node transforms for process AST before returning.
        New value could be iterable of:
            - NodeTransformer subclasses, will be instantiated and used with .visit method
            - NodeTransformer instances, will by used the .visit method
            - callable object, directly the item will be used
            - otherwise AssertionError raised
        :param transforms: Iterable of items described above
        """
        assert isinstance(transforms, Iterable)
        self._transforms = tuple(filter(
            None,
            ((
                 transform().visit  # given as class, so instantiated and get the .visit
                 if isinstance(transform, type) and issubclass(transform, NodeTransformer)
                 else transform.visit  # given and transform object, directly get the .visit
                 if isinstance(transform, NodeTransformer)
                 else transform  # directly callable
                 if callable(transform)
                 else None  # otherwise filtered by filter(None, ...)
             ) for transform in transforms
             )
        ))  # type: Tuple[Callable[[AST], AST]]
        # TODO: Assertion or TypeError?
        assert len(self._transforms) == len(transforms), 'Unknown transform(s) given.'

    transforms = property(fset=set_transforms)

    def set_preprocessors(self, preprocessors: Sized) -> None:
        """
        Sets expression preprocessors, whose are used before AST parsing.
        :param preprocessors: Iterable of callable or type for preprocessors.
        """
        assert isinstance(preprocessors, Iterable)
        self._preprocessors = tuple(filter(
            None,
            ((
                 preprocessor()
                 if isinstance(preprocessor, type)
                 else preprocessor
                 if callable(preprocessor)
                 else None
             ) for preprocessor in preprocessors
             )
        ))  # type: Tuple[Callable[str], str]

        # TODO: Assertion or TypeError?
        assert len(self._preprocessors) == len(preprocessors), 'Unknown preprocessor(s) given.'

    preprocessors = property(fset=set_preprocessors)
