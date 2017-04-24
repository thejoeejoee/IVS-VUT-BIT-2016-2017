# coding=utf-8

import re
from typing import Tuple, List

from calculator.settings import BuiltinFunction

__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class FactorialPreprocessor(object):
    """
    Preprocessor, that converts factorial sign to function call:
    5! -> fact(5)
    (5 + 2)! -> fact(5 + 2)
    (5! + 2)! -> fact(fact(5) + 2)
    """
    FACTORIAL_SIGN = '!'

    # position is reverted, because factorial is matched from !, which is at the end of wanted expression
    _MATH_EXPRESSION_REGEX = re.compile(
        r'''
            [\wA-F.]+ # number or variable name
            |
            \)[\w+-/* ]+\(\w* # or function call with any arguments
            |
            \)[()\w+-/* ]+\( # or any expression
        ''',
        re.VERBOSE
    )

    def __call__(self, expression: str) -> str:
        """
        Performs the conversion.
        :param expression: math expression as string
        :return: processed expression as string
        """
        if self.FACTORIAL_SIGN not in expression:
            return expression

        tokens = list(expression)
        while self.FACTORIAL_SIGN in tokens:
            factorial_index = tokens.index('!')
            replacement, length_of_replacement = self._get_replacement_literal_by_function_call(
                tokens=tokens[factorial_index - 1::-1]
            )
            tokens[factorial_index - length_of_replacement: factorial_index + 1] = replacement

        return ''.join(tokens)

    @classmethod
    def _get_replacement_literal_by_function_call(cls, tokens: List[str]) -> Tuple[str, int]:
        """
        Gets matched tokens and generates the correct replacement with length of str to remove from original.
        From ')5 + 9(' generates fact(9 + 5).
        From 9 generates simply fact(9).
        :param tokens: list of str tokens - reversed
        :return: tuple of (replacement, length of matched expression)
        """
        inner_expression = cls._MATH_EXPRESSION_REGEX.match(''.join(tokens))
        assert inner_expression, 'Regex should match the input tokens.'
        matched_group = inner_expression.group()
        add_brackets = not matched_group.startswith(')') or not matched_group.endswith('(')

        return ''.join((
            BuiltinFunction.FACT,
            '(' * add_brackets,
            ''.join(map(str, reversed(matched_group))),
            ')' * add_brackets
        )), len(matched_group)
