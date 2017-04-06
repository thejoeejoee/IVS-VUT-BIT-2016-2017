# coding=utf-8
import re
from decimal import Decimal
from inspect import Signature, Parameter

from calculator import NumericValue
from calculator.exceptions import UnsupportedBaseError
from calculator.settings import SUPPORTED_BASES


class Formatter(object):
    DEFAULT_CHARACTERS_LIMIT = 8

    EXP_FORMAT = '{value}<small>&times;</small><small>10</small><sup><small>{exp}</small></sup>'
    BASE_CONVERTERS = {
        2: bin,
        8: oct,
        16: hex,
        10: str
    }
    CLASS_TO_TYPE_REGEX = re.compile(r"(?<=').+(?=')", re.VERBOSE)

    _EXP_DIVIDER = 'e'

    @classmethod
    def format_number(cls, value: NumericValue, characters_limit: int = DEFAULT_CHARACTERS_LIMIT) -> str:
        stringed = str(value)

        if cls._EXP_DIVIDER not in stringed and not (len(stringed) > characters_limit):
            return stringed[:characters_limit]

        value, exp = '{:.2e}'.format(Decimal.from_float(value)).split(cls._EXP_DIVIDER)
        return cls.EXP_FORMAT.format(
            value=value,
            exp=exp.lstrip('+')
        )

    @classmethod
    def format_number_in_base(cls, value: str, base: int) -> str:
        """
        Formats the given number to string in given base.
        :param value: value, to be formatted
        :param base: base of formatted value
        :return: formatted value in wanted base
        """
        value = float(value)

        if abs(value - int(value)):
            raise ValueError('Only integer values can be formatted into other bases.')
        if base not in SUPPORTED_BASES:
            raise UnsupportedBaseError("Base {} is not supported.".format(base))

        return cls.BASE_CONVERTERS.get(base, str)(int(value))

    @classmethod
    def format_function_args_spec(cls, func_identifier: str, func_signature: Signature) -> str:
        """
        From function name and signature formats informal string to represent parameter types of given function.
        :param func_identifier: function name
        :param func_signature: Signature object
        :return: formatted string
        """
        raw_args = [
            (arg_identifier,
             func_signature.parameters[arg_identifier].default,
             func_signature.parameters[arg_identifier].annotation,
             )
            for arg_identifier in func_signature.parameters.keys()
            ]

        formatted_args = list()
        for identifier, default, annotation in raw_args:
            annotation_repr = repr(annotation)

            formatted_args.append((
                identifier,
                default,
                cls.CLASS_TO_TYPE_REGEX.search(annotation_repr).group(0)
                if "<class" in annotation_repr else
                annotation_repr.split("typing.")[-1]
                if 'typing.' in annotation_repr else
                annotation.__name__
            ))

        return "{identifier}({params})".format(
            identifier=func_identifier,
            params=", ".join((
                "{identifier}{default}: {type}".format(
                    identifier=identifier,
                    default=' = {}'.format(default) if default != Parameter.empty else '',
                    type=annotation
                ) for identifier, default, annotation in formatted_args
            ))
        )
