# coding=utf-8
from enum import IntEnum
from typing import Optional

from PyQt5.QtCore import QObject, Q_ENUMS
from PyQt5.QtQml import QQmlEngine, QJSEngine


class Sides(QObject):
    class SidesEnum(IntEnum):
        Top = 0
        Right = 1
        Bottom = 2
        Left = 3

    Q_ENUMS(SidesEnum)

    def oppositeSide(self, side: SidesEnum):
        if side in (Sides.SidesEnum.Top, Sides.SidesEnum.Right):
            return Sides.SidesEnum(side + 2)
        return Sides.SidesEnum(side - 2)

    @staticmethod
    def singletonProvider(engine: QQmlEngine, script_engine: QJSEngine) -> QObject:
        return Sides()
