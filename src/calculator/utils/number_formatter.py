# coding=utf-8
from decimal import Decimal

from calculator.typing import NumericValue


class NumberFormatter(object):
    DEFAULT_CHARACTERS_LIMIT = 8

    @staticmethod
    def format(value: NumericValue, characters_limit: int = DEFAULT_CHARACTERS_LIMIT) -> str:
        stringed = str(value)

        if len(stringed) <= characters_limit:
            return stringed

        if value > (10 ** characters_limit):
            return '{:.2e}'.format(Decimal.from_float(value))

        return stringed[:characters_limit]
