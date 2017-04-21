# coding=utf-8
from typing import Union, Tuple, Callable, Set, NewType
 
__author__ = "Josef Kolář, Martin Omacht"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"

NumericValue = NewType('NumericValue', Union[int, float])  # possible types of result of mathematical expression

Variable = Tuple[
    NumericValue,  # actual value
    str,  # raw source expression
    Set[str]  # dependencies
]

NumericFunction = Callable[..., NumericValue]

BinaryNumericFunction = Callable[[NumericValue, NumericValue], NumericValue]