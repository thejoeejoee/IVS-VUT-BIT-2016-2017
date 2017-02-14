# coding=utf-8
import re


class AbsoluteValuePreprocessor(object):
    """
    Preprocessor, which converts all absolute values in expression to call math function abs.
    |x| -> abs(x)
    |3 + |3 - 6|| -> abs(3 + abs(3 - 6))
    """
    ABSOLUTE_VALUE_SIGN = '|'
    ABSOLUTE_VALUE_FUNCTION_NAME = 'abs'

    _OPENING_SIGN_REGEX = re.compile(r'''
        (?: # non capturing group
            ^ # is begin of expression
            | # or
            [+-/*(,] # before is one of operators
        )
        \s* # followed by any occurrences of white chars
        (?P<abs_sign>\|) # and matched | char
    ''', re.VERBOSE)

    def __call__(self, expression: str) -> str:
        if self.ABSOLUTE_VALUE_SIGN not in expression:
            return expression

        tokens = list(expression)

        match = self._OPENING_SIGN_REGEX.search(''.join(tokens))
        while match:
            # opening | found, replace by abs(
            tokens[match.start('abs_sign'):match.end('abs_sign')] = '{}('.format(self.ABSOLUTE_VALUE_FUNCTION_NAME)
            match = self._OPENING_SIGN_REGEX.search(''.join(tokens))

        # replace all remaining | by closing )
        return ''.join(tokens).replace(self.ABSOLUTE_VALUE_SIGN, ')')
