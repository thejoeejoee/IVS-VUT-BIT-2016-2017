# coding=utf-8
 
__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class CaretPowerPreprocessor(object):
    """
    Preprocessor, which converts all carets as ^ (as xor) to ** (as power).
    """
    CARET_SIGN = '^'
    POWER_SIGN = '**'

    def __call__(self, expression: str) -> str:
        return expression.replace(self.CARET_SIGN, self.POWER_SIGN)