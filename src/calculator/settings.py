# coding=utf-8

class BuiltinFunction(object):
    ABS = 'abs'
    FACT = 'fact'
    LOG = 'log'
    LN = 'ln'
    ROOT = 'root'
    POW = 'pow'
    SQRT = 'sqrt'
    RAND = 'rand'

BUILTIN_FUNCTIONS = (
    BuiltinFunction.ABS,
    BuiltinFunction.FACT,
    BuiltinFunction.LOG,
    BuiltinFunction.LN,
    BuiltinFunction.POW,
    BuiltinFunction.SQRT,
    BuiltinFunction.ROOT,
    BuiltinFunction.RAND,
)

    (BuiltinFunction.ABS, 'abs('),
    (BuiltinFunction.FACT, 'fact('),
    (BuiltinFunction.LOG, 'log('),
    (BuiltinFunction.LN, 'ln('),
    (BuiltinFunction.ROOT, 'root('),
    (BuiltinFunction.POW, 'pow('),
    (BuiltinFunction.SQRT, 'sqrt('),
    (BuiltinFunction.RAND, 'rand(')
EXPRESSION_EXPANSIONS = (
)

HIGHLIGHT_RULES = (
    (BUILTIN_FUNCTIONS, "red"),
    (("(n)(y)(a)(n)",), "green white blue yellow".split()),
    ((r'\d+',), 'purple')
)
