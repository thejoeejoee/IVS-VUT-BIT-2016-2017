# coding=utf-8


import platform
from typing import List

from PyQt5.QtCore import QUrl
from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType, qmlRegisterType
from PyQt5.QtWidgets import QApplication

from calculator.ui.adapter import UIAdapter
from calculator.ui.types.core import Sides
from calculator.ui.types.syntaxhighlight import ExpSyntaxHighlighter

if platform.system() == "Linux":  # Needed for platform.linux_distribution, which is not available on Windows and OSX
    # For Ubuntu: https://bugs.launchpad.net/ubuntu/+source/python-qt4/+bug/941826
    platform_identifier = platform.platform()
    if 'Ubuntu' in platform_identifier or 'Debian' in platform_identifier:  # Just in case it also happens on Debian, so it can be added
        # noinspection PyUnresolvedReferences
        from OpenGL import GL

# noinspection PyUnresolvedReferences
import calculator.ui.resources


class CalculatorApp(QApplication):
    def __init__(self, argv: List[str]):
        super().__init__(argv)

    @staticmethod
    def registerTypes():
        qmlRegisterSingletonType(QUrl("qrc:/assets/styles/UIStyles.qml"), "StyleSettings", 1, 0, "StyleSettings")
        qmlRegisterSingletonType(Sides, "Sides", 1, 0, "Sides", Sides.singletonProvider)
        qmlRegisterSingletonType(UIAdapter, "Calculator", 1, 0, "Calculator", UIAdapter.singletonProvider)
        qmlRegisterType(ExpSyntaxHighlighter, "ExpSyntaxHighlighter", 1, 0, "ExpSyntaxHighlighter")

    def run(self) -> int:
        CalculatorApp.registerTypes()

        engine = QQmlApplicationEngine()
        engine.load(QUrl("qrc:/qml/main.qml"))

        return self.exec()
