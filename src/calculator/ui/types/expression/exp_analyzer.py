# coding=utf-8
import re

from typing import Optional

from PyQt5.QtCore import QObject, pyqtSignal, pyqtProperty, pyqtSlot
from PyQt5.QtQuick import QQuickItem

from calculator.settings import EXPRESSION_SPLITTERS


class ExpAnalyzer(QObject):
    targetChanged = pyqtSignal(QQuickItem)

    def __init__(self, parent: Optional[QObject] = None) -> None:
        super().__init__(parent)

        self._target = None

    def _get_content(self):
        return self._target.property("text")

    def _get_cursor(self):
        return self._target.property("cursorPosition")

    def _get_selection(self):
        return (self._target.property("selectionStart"),
                self._target.property("selectionEnd"),
                self._target.property("selectedText"))

    @pyqtSlot(result=str)
    def currentWord(self):
        """
        According to cursor in text it determines current word which is edited
        :return: Current word
        """

        content = self._get_content()
        cursor = self._get_cursor()
        word_start = 0
        word_end = len(content)

        if self._get_cursor() == 0:
            return ""

        splitter_positions = list()
        for splitter in EXPRESSION_SPLITTERS:
            splitter_positions.extend([i for i, letter in enumerate(content) if letter == splitter])

        left_splitters_pos = list(filter(lambda x: x <= cursor, splitter_positions))
        right_splitters_pos = list(filter(lambda x: x > cursor, splitter_positions))

        if left_splitters_pos:
            word_start = min(left_splitters_pos, key=lambda x: abs(x - cursor)) + 1
        if right_splitters_pos:
            word_end = min(right_splitters_pos, key=lambda x: abs(x - cursor))

        return re.escape(content[word_start: word_end:].strip())

    @pyqtProperty(QQuickItem)
    def target(self) -> QQuickItem:
        return self._target

    @target.setter
    def target(self, v: QQuickItem) -> None:
        if self._target != v:
            self._target = v
            self.targetChanged.emit(v)