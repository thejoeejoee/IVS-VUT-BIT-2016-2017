# coding=utf-8

import re


class FactorialPreprocessor(object):
    FACTORIAL_FUNCTION_NAME = 'fact'
    _MATH_EXPRESSION_REGEX = re.compile(
        r'''
            [\dA-F.]+|
            \)[()\d\w.+-/* ]+\(\w*|
            \)[()\d\w.+-/* ]+\(|
        ''',
        re.VERBOSE
    )

    def __call__(self, expression: str):
        if '!' not in expression:
            return expression

        tokens = list(expression)
        # TODO: '!' as constant
        while '!' in tokens:
            factorial_index = tokens.index('!')
            replacement, length_of_replacement = self._get_replacement_literal_by_function_call(
                tokens=tokens[factorial_index - 1::-1]
            )
            tokens[factorial_index - length_of_replacement: factorial_index + 1] = replacement

        return ''.join(tokens)

    @classmethod
    def _get_replacement_literal_by_function_call(cls, tokens):
        inner_expression = cls._MATH_EXPRESSION_REGEX.match(''.join(tokens))
        assert inner_expression
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
