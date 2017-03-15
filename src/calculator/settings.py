# coding=utf-8
from enum import IntEnum

from PyQt5.QtCore import QObject, Q_ENUMS
from PyQt5.QtQml import QQmlEngine, QJSEngine


class BuiltinFunction(object):
    ABS = 'abs'
    FACT = 'fact'
    LOG = 'log'
    LN = 'ln'
    ROOT = 'root'
    POW = 'pow'
    SQRT = 'sqrt'
    RAND = 'rand'


class Expansion(QObject):
    class ExpansionType(IntEnum):
        NORMAL = 0
        BRACKETS_PACK = 1

    Q_ENUMS(ExpansionType)

    @staticmethod
    def singletonProvider(engine: QQmlEngine, script_engine: QJSEngine) -> QObject:
        return Expansion()

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

HIGHLIGHT_RULES = (
    (BUILTIN_FUNCTIONS, "red"),
    ((r'\d+',), 'purple'),
    (("(n)(y)(a)(n)",), "#ED1869 #F2BC1F #39BFC1 #672980".split()),
)

EXPRESSION_EXPANSIONS = (
    (BuiltinFunction.ABS, 'abs(', Expansion.ExpansionType.BRACKETS_PACK),
    (BuiltinFunction.FACT, 'fact(', Expansion.ExpansionType.BRACKETS_PACK),
    (BuiltinFunction.LOG, 'log(', Expansion.ExpansionType.BRACKETS_PACK),
    (BuiltinFunction.LN, 'ln(', Expansion.ExpansionType.BRACKETS_PACK),
    (BuiltinFunction.ROOT, 'root(', Expansion.ExpansionType.BRACKETS_PACK),
    (BuiltinFunction.POW, 'pow(', Expansion.ExpansionType.BRACKETS_PACK),
    (BuiltinFunction.SQRT, 'sqrt(', Expansion.ExpansionType.BRACKETS_PACK),
    (BuiltinFunction.RAND, 'rand(', Expansion.ExpansionType.BRACKETS_PACK)
)
