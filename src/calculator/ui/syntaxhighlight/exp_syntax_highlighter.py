# coding=utf-8
from typing import Optional, List

from PyQt5.QtCore import QObject, QRegularExpression, pyqtProperty
from PyQt5.QtGui import QColor, QFont
from PyQt5.QtGui import QTextCharFormat
from PyQt5.QtQuick import QQuickItem

from calculator.ui.syntaxhighlight import SyntaxHighlighter, HighlightRule


class ExpSyntaxHighlighter(QObject):
    """
    Class which wraps SyntaxHighliter and expose only target
    """

    def __init__(self, parent: Optional[QObject] = None):
        super().__init__(parent)

        self._syntax_highlighter = SyntaxHighlighter(self)

    def addHighlightRule(self, patterns: List[str], color: QColor, fontSettings: QFont) -> None:
        """
        Adds highlight rule to syntax highlighter
        :param patterns: Regexp pattners to be matched
        :param color: Foreground color of matched text
        :param fontSettings: Determinates font weight and italic
        """

        pattern_format = QTextCharFormat()
        pattern_format.setForeground(color)
        pattern_format.setFontItalic(fontSettings.italic())
        pattern_format.setFontWeight(fontSettings.bold())

        for single_patten in patterns:
            self._syntax_highlighter.addHighlightRule(
                HighlightRule(pattern_format, QRegularExpression(single_patten))
            )

    @pyqtProperty(QQuickItem)
    def target(self) -> None:
        return self._syntax_highlighter.target

    @target.setter
    def target(self, v: QQuickItem) -> None:
        self._syntax_highlighter.target = v