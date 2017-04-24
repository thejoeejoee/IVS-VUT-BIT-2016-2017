# coding=utf-8
import sys
from fileinput import input

from calculator.core.math import Math

__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


def mean(values):
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


def standard_deviation(values):
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


def main(file_input):
    """
    Process FileInput instance, computes standard deviation of loaded numbers and print on stdout the value of SD.
    :param file_input: FileInput instance to process
    :return: None
    """
    values = list()
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
