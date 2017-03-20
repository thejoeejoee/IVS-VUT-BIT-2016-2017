# coding=utf-8
import platform
from typing import List

from PyQt5.QtCore import QSize
from PyQt5.QtCore import QTranslator
from PyQt5.QtCore import QUrl, QLocale
from PyQt5.QtGui import QIcon
from PyQt5.QtGui import QPixmap
from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType, qmlRegisterType
from PyQt5.QtWidgets import QApplication

from calculator.ui.adapter import UIAdapter
from calculator.ui.types.core import Sides
from calculator.ui.types.syntaxhighlight import ExpSyntaxHighlighter
from calculator.ui.types.qmlwrapper.utils import TypeRegister
from calculator.settings import Expansion, ICON_SIZES

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

        self._translator = QTranslator()
        self._translator.load("".join((":/translations/", QLocale().system().name(), ".qsm")))
        self.installTranslator(self._translator)

        print(QPixmap(":/assets/images/icon.png").width())
        icon = QIcon()

        for size in ICON_SIZES:
            print(":/assets/icons/{}x{}.png".format(size, size))
            icon.addFile(":/assets/icons/{}x{}.png".format(size, size), QSize(size, size))
            #icon.addPixmap(QPixmap(":/assets/icons/{}x{}.png".format(size, size)))

        self.setWindowIcon(icon)

    @staticmethod
    def registerTypes():
        qmlRegisterSingletonType(QUrl("qrc:/assets/styles/UIStyles.qml"), "StyleSettings", 1, 0, "StyleSettings")
        qmlRegisterSingletonType(Sides, "Sides", 1, 0, "Sides", Sides.singletonProvider)
        qmlRegisterSingletonType(Expansion, "Expansion", 1, 0, "Expansion", Expansion.singletonProvider)
        qmlRegisterSingletonType(UIAdapter, "Calculator", 1, 0, "Calculator", UIAdapter.singletonProvider)
        TypeRegister.register_type(ExpSyntaxHighlighter)

    def run(self) -> int:
        CalculatorApp.registerTypes()

        engine = QQmlApplicationEngine()
        engine.load(QUrl("qrc:/qml/main.qml"))

        return self.exec()
