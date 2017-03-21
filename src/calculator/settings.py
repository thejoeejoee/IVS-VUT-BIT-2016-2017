# coding=utf-8
from enum import IntEnum

from PyQt5.QtCore import QObject, Q_ENUMS
from PyQt5.QtQml import QQmlEngine, QJSEngine

ICON_SIZES = (16, 24, 32, 48, 256)

class BuiltinFunction(object):
    ABS = 'abs'
    FACT = 'fact'
    LOG = 'log'
    LN = 'ln'
    ROOT = 'root'
    POW = 'pow'
    SQRT = 'sqrt'
    RAND = 'rand'


EXPRESSION_SPLITTERS = ("+", "-", "(")
class Expression(QObject):
    class ExpressionTypes(IntEnum):
        Function = 0
        Variable = 1

    Q_ENUMS(ExpressionTypes)

    @staticmethod
    def singletonProvider(engine: QQmlEngine, script_engine: QJSEngine) -> QObject:
        return Expression()

class Expansion(QObject):
    class ExpansionType(IntEnum):
        Normal = 0
        BracketsPack = 1

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
