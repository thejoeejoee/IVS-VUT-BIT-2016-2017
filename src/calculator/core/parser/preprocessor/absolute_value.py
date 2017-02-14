# coding=utf-8


class AbsoluteValuePreprocessor(object):
    """
    Preprocessor, which converts all absolute values in expression to call math function abs.
    |x| -> abs(x)
    |3 + |3 - 6|| -> abs(3 + abs(3 - 6))
    """
    ABSOLUTE_VALUE_SIGN = '|'
    ABSOLUTE_VALUE_FUNCTION_NAME = 'abs'

    def __call__(self, expression: str) -> str:
        if self.ABSOLUTE_VALUE_SIGN not in expression:
            return expression

        # TODO: rewrite |x| to abs(x) call
        return expression
