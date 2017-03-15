# coding=utf-8
from calculator.typing import NumericValue


class NumberFormatter(object):
    DEFAULT_CHARACTERS_LIMIT = 8

    @staticmethod
    def format(value: NumericValue, characters_limit: int = DEFAULT_CHARACTERS_LIMIT) -> str:
        return ''
