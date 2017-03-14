# coding=utf-8


class ParserSyntaxError(SyntaxError):
    """
    Raised from Parser to signalize syntax error (invalid operands, brackets, numbers).
    """


class SyntaxRestrictError(SyntaxError):
    """
    Raised as syntax restrict from Parser like complex numbers etc.
    """


class MathError(ArithmeticError):
    """
    Standard Math error - division by null etc.
    """


class VariableError(Exception):
    """
    Exception for signalizing of invalid definition for calculator variable.
    """