# coding=utf-8
from enum import IntEnum
from typing import Optional

from PyQt5.QtCore import QObject, Q_ENUMS, pyqtSlot
from PyQt5.QtQml import QQmlEngine, QJSEngine
 
__author__ = "Son Hai Nguyen"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class Sides(QObject):
    class SidesEnum(IntEnum):
        Top = 0
        Right = 1
        Bottom = 2
        Left = 3

    Q_ENUMS(SidesEnum)

    @pyqtSlot(int)
    def oppositeSide(self, side: SidesEnum):
        if side in (Sides.SidesEnum.Top, Sides.SidesEnum.Right):
            return Sides.SidesEnum(side + 2)
        return Sides.SidesEnum(side - 2)

    @staticmethod
    def singletonProvider(engine: QQmlEngine, script_engine: QJSEngine) -> QObject:
        return Sides()