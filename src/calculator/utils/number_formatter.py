# coding=utf-8
import re

from decimal import Decimal

from inspect import Signature

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

    @staticmethod
    def format_function_args_spec(func_identifier: str, func_signature: Signature) -> str:
        raw_args = [(arg_identifier, func_signature.parameters[arg_identifier].annotation)
                    for arg_identifier in func_signature.parameters.keys()]
        formatted_args_list = list()

        for arg_identifier, arg_annotation in raw_args:
            arg_annotation = repr(arg_annotation)

            if "<class" in arg_annotation:
                formatted_args_list.append((arg_identifier, re.search("(?<=').+(?=')", arg_annotation).group(0)))
            else:
                formatted_args_list.append((arg_identifier, arg_annotation.split("typing.")[-1]))

        formatted_args = "{}({})".format(func_identifier, ", ".join(["{}: {}".format(
            arg_identifier,
            arg_annotation
        )
        for arg_identifier, arg_annotation in formatted_args_list]))

        return formatted_args
