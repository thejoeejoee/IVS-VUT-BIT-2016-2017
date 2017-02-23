# coding=utf-8
from typing import Optional, Union

from PyQt5.QtCore import pyqtSignal, QObject, pyqtProperty, QRegularExpression, pyqtSlot
from PyQt5.QtGui import QSyntaxHighlighter, QTextCharFormat
from PyQt5.QtQuick import QQuickItem, QQuickTextDocument


class HighlightRule(QObject):
    def __init__(self, textFormat: Optional[QTextCharFormat] = None, matchPattern: Optional[QRegularExpression] = None) -> None:
        """
        :param textFormat: Text format of text mathched by pattern
        :param matchPattern: Regex pattern to match wanted text
        """

        super().__init__(None)

        self._text_format = textFormat
        self._match_pattern = matchPattern

    @property
    def text_format(self) -> Union[QTextCharFormat, None]:
        return self._text_format

    @property
    def match_pattern(self) -> Union[QRegularExpression, None]:
        return self._match_pattern


class SyntaxHighlighter(QSyntaxHighlighter):
    """
    SyntaxHighlighter, which highlights text pattern with certain text format
    """

    targetChanged = pyqtSignal(QQuickItem)

    def __init__(self, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)

        self._target = None
        self._highlight_rules = list()

        self.targetChanged.connect(self._setupNewDocument)

    def highlightBlock(self, p_str: str) -> None:
        """
         Virtual method, which is called when block of text changed
         :param p_str: Block of text which changed
        """

        for rule in self._highlight_rules:
            cursor = 0
            match_pattern = rule.match_pattern

            while match_pattern.match(p_str, cursor).hasMatch():
                match = match_pattern.match(p_str, cursor)

                self.setFormat(
                    match.capturedStart(),
                    match.capturedLength(),
                    rule.text_format
                )
                cursor = match.capturedStart() + match.capturedLength()

    def addHighlightRule(self, highlightRule: HighlightRule) -> None:
        self._highlight_rules.append(highlightRule)

    @pyqtSlot(QQuickItem)
    def _setupNewDocument(self, target: QQuickItem) -> None:
        """
        Extract set new document from target
        :param target: Item, from which document which will extracted
        """

        print(target.property("textDocument").textDocument())
        self.setDocument(target.property("textDocument").textDocument())

    @pyqtProperty(QQuickItem)
    def target(self) -> QQuickItem:
        return self._target

    @target.setter
    def target(self, v: QQuickItem) -> None:
        if self._target != v:
            self._target = v
            self.targetChanged.emit(v)