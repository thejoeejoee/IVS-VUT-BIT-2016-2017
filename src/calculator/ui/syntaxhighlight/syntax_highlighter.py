# coding=utf-8
from typing import Optional, Union

from PyQt5.QtCore import pyqtSignal, QObject, pyqtProperty, QRegularExpression
from PyQt5.QtGui import QSyntaxHighlighter, QTextCharFormat


class HighlightRule:
    def __init__(self, textFormat: Optional[QTextCharFormat] = None, matchPattern: Optional[QRegularExpression] = None) -> None:
        self._text_format = textFormat
        self._match_pattern = matchPattern

    @property
    def textFormat(self) -> Union[QTextCharFormat, None]:
        return self._text_format

    @textFormat.setter
    def textFormat(self, v: QTextCharFormat) -> None:
        self._text_format = v

    @property
    def match_pattern(self) -> Union[QRegularExpression, None]:
        return self._match_pattern

    @match_pattern.setter
    def match_pattern(self, v: QRegularExpression) -> None:
        self._match_pattern = v


class SyntaxHighLighter(QSyntaxHighlighter):
    targetChanged = pyqtSignal(QObject)

    def __init__(self, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)

        self._target = None
        self._highlight_rules = list()

    def highlightBlock(self, p_str):
        for rule in self._highlight_rules:
            pass

    def addHighlightRule(self, highlightRule: HighlightRule) -> None:
        self._highlight_rules.append(highlightRule)

    @pyqtProperty(QObject)
    def target(self) -> QObject:
        return self._target

    @target.setter
    def target(self, v) -> None:
        if self._target != v:
            self._target = v
            self.targetChanged.emit(v)