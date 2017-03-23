# coding=utf-8
from decimal import Decimal

from calculator._typing import NumericValue


class NumberFormatter(object):
    DEFAULT_CHARACTERS_LIMIT = 8

    EXP_FORMAT = '{value} <small>&times;</small>10<sup><small>{exp}</small></sup>'

    _EXP_DIVIDER = 'e'

    @classmethod
    def format(cls, value: NumericValue, characters_limit: int = DEFAULT_CHARACTERS_LIMIT) -> str:
        stringed = str(value)

        if cls._EXP_DIVIDER not in stringed and not (len(stringed) > characters_limit):
            return stringed[:characters_limit]

        value, exp = '{:.2e}'.format(Decimal.from_float(value)).split(cls._EXP_DIVIDER)
        return cls.EXP_FORMAT.format(
            value=value,
            exp=exp.lstrip('+')
        )
