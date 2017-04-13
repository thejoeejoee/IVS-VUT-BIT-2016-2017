# coding=utf-8
import platform
from typing import List

from termcolor import colored

from PyQt5.QtCore import (QSize, QtFatalMsg, QtCriticalMsg, QtWarningMsg, QtInfoMsg,
                          qInstallMessageHandler, QtDebugMsg)
from PyQt5.QtCore import QTranslator
from PyQt5.QtCore import QUrl, QLocale
from PyQt5.QtGui import QIcon
from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType
from PyQt5.QtWidgets import QApplication

from calculator.ui.adapter import UIAdapter
from calculator.ui.types.core import Sides
from calculator.ui.types.expression import ExpSyntaxHighlighter, ExpAnalyzer
from calculator.ui.types.qmlwrapper.utils import TypeRegister
from calculator.ui.types.window import AppWindow
from calculator.settings import Expansion, ICON_SIZES, Expression, SUPPORTED_LANGUAGES

if platform.system() == "Linux":  # Needed for platform.linux_distribution, which is not available on Windows and OSX
    # For Ubuntu: https://bugs.launchpad.net/ubuntu/+source/python-qt4/+bug/941826
    platform_identifier = platform.platform()
    # Just in case it also happens on Debian, so it can be added
    if 'Ubuntu' in platform_identifier or 'Debian' in platform_identifier:
        # noinspection PyUnresolvedReferences
        from OpenGL import GLU
        # noinspection PyUnresolvedReferences
        from OpenGL import GL

# noinspection PyUnresolvedReferences
import calculator.ui.resources


def qt_message_handler(mode, context, message):
    modes = {
        QtInfoMsg: "Info",
        QtWarningMsg: "Warning",
        QtCriticalMsg: "Critical",
        QtFatalMsg: "Fatal",
        QtDebugMsg: "Debug"
    }

    modes_colors = {
        QtInfoMsg: "blue",
        QtWarningMsg: "yellow",
        QtCriticalMsg: "red",
        QtFatalMsg: "red",
        QtDebugMsg: "green"
    }

    mode = colored(modes[mode], modes_colors[mode])

    if context.file is None:
        print('{mode}: {msg}'.format(mode=mode, msg=message))
    else:
        print('{mode}: {msg}\t\t\t\tline: {line}, function: {func}, file: {file}'.format(
            mode=mode, line=context.line, func=context.function, file=context.file, msg=message))

qInstallMessageHandler(qt_message_handler)

class CalculatorApp(QApplication):
    def __init__(self, argv: List[str]):
        super().__init__(argv)

        self._translator = QTranslator()

        language_name =  QLocale().system().bcp47Name()
        translation_file_path = ":/translations/en.qm"

        if language_name in SUPPORTED_LANGUAGES:
            translation_file_path = "".join((":/translations/", language_name, ".qm"))
        self._translator.load(translation_file_path)
        self.installTranslator(self._translator)
        icon = QIcon()

        for size in ICON_SIZES:
            icon.addFile(":/assets/icons/{}x{}.png".format(size, size), QSize(size, size))

        self.setWindowIcon(icon)

    @staticmethod
    def registerTypes():
        qmlRegisterSingletonType(QUrl("qrc:/assets/styles/UIStyles.qml"), "StyleSettings", 1, 0, "StyleSettings")
        qmlRegisterSingletonType(Sides, "Sides", 1, 0, "Sides", Sides.singletonProvider)
        qmlRegisterSingletonType(Expansion, "Expansion", 1, 0, "Expansion", Expansion.singletonProvider)
        qmlRegisterSingletonType(Expression, "Expression", 1, 0 ,"Expression", Expression.singletonProvider)
        qmlRegisterSingletonType(UIAdapter, "Calculator", 1, 0, "Calculator", UIAdapter.singletonProvider)
        TypeRegister.register_type(ExpSyntaxHighlighter)
        TypeRegister.register_type(AppWindow)
        TypeRegister.register_type(ExpAnalyzer)

    def run(self) -> int:
        CalculatorApp.registerTypes()

        engine = QQmlApplicationEngine()
        engine.load(QUrl("qrc:/qml/main.qml"))

        return self.exec()
