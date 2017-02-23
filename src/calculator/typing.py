# coding=utf-8
from typing import Union, Tuple

NumericResult = Union[int, float]  # possible types of result of mathematical expression

Variable = Tuple[
    NumericResult,  # actual value
    str  # raw source expression
]