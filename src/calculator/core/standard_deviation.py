# coding=utf-8
from typing import Sequence

from calculator.core.math.math import Math
from calculator.typing import NumericResult


def mean(values: Sequence[NumericResult]) -> float:
    """
    Computes mean of given collection.
    :param values: collection of numeric values
    :return: computed mean
    """
    assert values, 'Non empty collection of numeric values.'
    return Math.divide(
        sum(values),
        len(values)
    )


def standard_deviation(values: Sequence[NumericResult]) -> float:
    """
    Computes corrected sample standard deviation by
    https://wikimedia.org/api/rest_v1/media/math/render/svg/1bffdcb1ecd0b326bb7ad67397b073af9c15fa6e
    :param values: numeric values to compute
    :return: standard deviation of given data
    """
    values_count = len(values)
    assert values_count >= 2, 'Standard deviation is defined for least 2 items.'
    computed_mean = mean(values=values)
    return Math.root(
        Math.divide(
            1,
            values_count - 1
        ) * sum(
            (value - computed_mean) ** 2
            for value
            in values
        )
    )
