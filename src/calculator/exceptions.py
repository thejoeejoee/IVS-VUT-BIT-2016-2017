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


class UnsupportedBaseError(Exception):
    """
    Raised when trying convert number into unsupported base
    """


class VariableRemoveRestrictError(VariableError):
    """
    Raised from Calculator, if there are any depending variables to variable to remove.
    """

    def __init__(self, dependencies, *args, **kwargs):
        self.dependencies = dependencies
        super().__init__(*args, **kwargs)


class InvalidFunctionCallError(TypeError):
    """
    Raised to signalize of call function with incorrect count of parameters.
    """

    def __init__(self, function_name, *args, **kwargs):
        self.function_name = function_name
        super().__init__(*args, **kwargs)
