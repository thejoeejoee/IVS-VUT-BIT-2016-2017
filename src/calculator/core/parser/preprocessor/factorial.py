# coding=utf-8


# TODO: wip
class FactorialPreprocessor(object):
    FACTORIAL_FUNCTION_NAME = 'fact'

    def __call__(self, expression: str):
        if '!' not in expression:
            return expression

        tokens = list(expression)
        reversed_tokens = list(reversed(tokens))

        while '!' in expression:
            factorial_index = expression.index('!')
            to_process = reversed_tokens[len(expression) - factorial_index:]
            return expression


        return expression

    @staticmethod
    def _get_replacement_literal_by_function_call(expression):
        return expression
