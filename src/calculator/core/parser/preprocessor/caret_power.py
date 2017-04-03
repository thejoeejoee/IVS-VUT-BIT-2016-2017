# coding=utf-8


class CaretPowerPreprocessor(object):
    """
    Preprocessor, which converts all carets as ^ (as xor) to ** (as power).
    """
    CARET_SIGN = '^'
    POWER_SIGN = '**'

    def __call__(self, expression: str) -> str:
        return expression.replace(self.CARET_SIGN, self.POWER_SIGN)
