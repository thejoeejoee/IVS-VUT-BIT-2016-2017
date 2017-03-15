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
    BuiltinFunction.ROOT,
    BuiltinFunction.SQRT,
    BuiltinFunction.RAND,
)

BUILTIN_FUNCTIONS_EXPANSION = (
    (BuiltinFunction.ABS, 'abs('),
    (BuiltinFunction.FACT, 'fact('),
    (BuiltinFunction.LOG, 'log('),
    (BuiltinFunction.LN, 'ln('),
    (BuiltinFunction.ROOT, 'root('),
    (BuiltinFunction.POW, 'pow('),
    (BuiltinFunction.SQRT, 'sqrt('),
    (BuiltinFunction.RAND, 'rand(')
)
