# coding=utf-8
from typing import Union, Tuple, Callable

NumericValue = Union[int, float]  # possible types of result of mathematical expression

Variable = Tuple[
    NumericValue,  # actual value
    str  # raw source expression
]

NumericFunction = Callable[..., NumericValue]

BinaryNumericFunction = Callable[[NumericValue, NumericValue], NumericValue]
