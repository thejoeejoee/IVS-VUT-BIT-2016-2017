# coding=utf-8

import re
from typing import Tuple, List


class FactorialPreprocessor(object):
    FACTORIAL_FUNCTION_NAME = 'fact'
    FACTORIAL_SIGN = '!'

    # position is reverted, because factorial is matched from !, which is at the end of wanted expression
    _MATH_EXPRESSION_REGEX = re.compile(
        r'''
            [\dA-F.]+ # number or variable name
            |
            \)[\d\w+-/* ]+\(\w* # or function call with any arguments
            |
            \)[()\d\w+-/* ]+\( # or any expression
        ''',
        re.VERBOSE
    )

    def __call__(self, expression: str) -> str:
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

        if matched_group.startswith(')') and matched_group.endswith('('):
            return '{func_name}{expression}'.format(
                func_name=cls.FACTORIAL_FUNCTION_NAME,
                expression=''.join(map(str, reversed(matched_group)))
            ), len(matched_group)

        return '{func_name}({expression})'.format(
            func_name=cls.FACTORIAL_FUNCTION_NAME,
            expression=''.join(map(str, reversed(matched_group)))
        ), len(matched_group)
