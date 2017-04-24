# coding=utf-8
import re

from calculator.settings import BuiltinFunction

__author__ = "Josef Kolář, Robert Navrátil"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class AbsoluteValuePreprocessor(object):
    """
    Preprocessor, which converts all absolute values in expression to call math function abs.
    |x| -> abs(x)
    |3 + |3 - 6|| -> abs(3 + abs(3 - 6))
    """
    ABSOLUTE_VALUE_SIGN = '|'

    _OPENING_SIGN_REGEX = re.compile(r'''
        (?: # non capturing group
            ^ # is begin of expression
            | # or
            [+-/*(,] # before is one of operators
        )
        \s* # followed by any occurrences of white chars
        (?P<abs>\|) # and matched | char
    ''', re.VERBOSE)

    def __call__(self, expression: str) -> str:
        if self.ABSOLUTE_VALUE_SIGN not in expression:
            return expression

        tokens = list(expression)

        match = self._OPENING_SIGN_REGEX.search(''.join(tokens))
        while match:
            # opening | found, replace by abs(
            tokens[match.start('abs'):match.end('abs')] = '{}('.format(BuiltinFunction.ABS)
            match = self._OPENING_SIGN_REGEX.search(''.join(tokens))

        # replace all remaining | by closing )
        return ''.join(tokens).replace(self.ABSOLUTE_VALUE_SIGN, ')')
