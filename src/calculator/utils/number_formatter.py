# coding=utf-8
from decimal import Decimal

from calculator import NumericValue
from calculator.settings import SUPPORTED_BASES

from calculator.exceptions import UnsupportedBaseError


class NumberFormatter(object):
    DEFAULT_CHARACTERS_LIMIT = 8

    EXP_FORMAT = '{value} <small>&times;</small>10<sup><small>{exp}</small></sup>'
    BASE_CONVERTERS = {2: bin, 8: oct, 16: hex, 10: lambda x: str(x)}

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

    @classmethod
    def format_in_base(cls, value: int, base: int) -> str:
        if abs(value - int(value)) > 0:
            raise ValueError()
        if not base in SUPPORTED_BASES:
            raise UnsupportedBaseError("Base {} is not supported.".format(base))

        return cls.BASE_CONVERTERS[base](int(value))