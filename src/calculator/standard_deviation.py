# coding=utf-8
import sys
from fileinput import FileInput, input
from typing import List
from typing import Sequence

from calculator.core.math import Math
from calculator.typing import NumericValue


def mean(values: Sequence[NumericValue]) -> float:
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


def standard_deviation(values: Sequence[NumericValue]) -> float:
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
        Math.multiple(
            Math.divide(
                1,
                Math.subtract(values_count, 1)
            ), sum(
                Math.pow(Math.subtract(value, computed_mean), 2)
                for value
                in values
            )
        )
    )


def main(file_input: FileInput) -> None:
    values = list()  # type: List[NumericValue]
    for line in file_input:
        if not line:
            continue
        try:
            values.append(float(line))
        except ValueError:
            print("Unknown line: '{}'".format(line), file=sys.stderr)

    print(standard_deviation(values=values))


if __name__ == '__main__':
    main(input())
