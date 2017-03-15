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
    (BuiltinFunction.ABS, 'abs(', Expansion.ExpansionType.BracketsPack),
    (BuiltinFunction.FACT, 'fact(', Expansion.ExpansionType.BracketsPack),
    (BuiltinFunction.LOG, 'log(', Expansion.ExpansionType.BracketsPack),
    (BuiltinFunction.LN, 'ln(', Expansion.ExpansionType.BracketsPack),
    (BuiltinFunction.ROOT, 'root(', Expansion.ExpansionType.BracketsPack),
    (BuiltinFunction.POW, 'pow(', Expansion.ExpansionType.BracketsPack),
    (BuiltinFunction.SQRT, 'sqrt(', Expansion.ExpansionType.BracketsPack),
    (BuiltinFunction.RAND, 'rand(', Expansion.ExpansionType.BracketsPack)
)
