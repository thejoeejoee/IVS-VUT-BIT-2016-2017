# coding=utf-8
import re
import inspect

from typing import Optional, Tuple, List, Dict

from PyQt5.QtCore import QObject, pyqtSignal, pyqtProperty, pyqtSlot, QVariant
from PyQt5.QtQuick import QQuickItem

from calculator.core.solver import Solver
from calculator.settings import EXPRESSION_SPLITTERS, EXPRESSION_EXPANSIONS, Expansion, BUILTIN_FUNCTIONS
from calculator.utils.formatter import Formatter

__author__ = "Son Hai Nguyen"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


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
    def currentFunctionSignature(self) -> str:
        """
        :return: Return signature of current function if cursor is not in body of any function then
        it returns empty string
        """
        func_identifier = self.currentFunction()

        if func_identifier in BUILTIN_FUNCTIONS:
            func = Solver.builtin_functions[func_identifier]

            try:
                return Formatter.format_function_args_spec(func_identifier, inspect.signature(func))
            except ValueError:
                print("No signature")
            return ""

    @pyqtSlot(result=str)
    def currentFunction(self) -> str:
        """
        :return: Identifier of function in which is cursor is located if cursor is not in body of
        funnction then it return empty string
        """

        cursor = self._get_cursor()
        content = self._get_content()
        functions = []
        mutable_content = list(content)

        for func in self._functions_list(content):
            start, end = self._function_body_borders(func, "".join(mutable_content))
            functions.append((func, start, end))

            for i in range(start - len(func) - 1, start):
                mutable_content[i] = "_"

        current_functions = []  # functions can be nested, so then display the most nested function

        for func, start, end in functions:
            if start <= cursor <= end + 1:
                current_functions.append((func, end - start + 1))

        if current_functions:
            return min(current_functions, key=lambda t: t[1])[0]
        return ""

    def _function_body_borders(self, func: str, expr: str) -> Tuple[int, int]:
        """
        :param func: Function identifier
        :param expr: Expression where it will be finding
        :return: Start and end index of body of function
        """
        brackets_count = {"(": 1, ")": 0}  # 1 for function
        match = re.search('{} *\('.format(re.escape(func)), expr)

        for i in range(match.end(), len(expr)):
            current_char = expr[i]

            if current_char in "()":
                brackets_count[current_char] += 1

            if brackets_count["("] == brackets_count[")"]:
                return match.end(), i - 1
        return match.end(), len(expr)

    def _functions_list(self, expr: str) -> List[str]:
        """
        Return list of all functions identifiers including desirable duplication
        :param expr: Input string expression
        :return: List of functions identifiers
        """
        result = []

        for splitter in EXPRESSION_SPLITTERS - {"("}:
            expr = expr.replace(splitter, ".")
        splitted_expressions = [s.strip() for s in expr.split(".")]

        for e in splitted_expressions:
            result.extend([match.group() for match in re.finditer('(?!(\(|\)| |\.)).+?(?=\()', e)])

        return result

    @pyqtSlot(str, result=int)
    def expansionType(self, expansion: str) -> int:
        """
        Return type of expansion.
        :param expansion: String to expand
        :return: Type of expansion
        """

        try:
            return {func: expansion_type
                    for func, _, expansion_type in EXPRESSION_EXPANSIONS}[expansion]
        except KeyError:
            return Expansion.ExpansionType.Normal

    @pyqtSlot(str, result=str)
    def getExpansion(self, expansion: str) -> str:
        """
        Return Whole expansion if expansion is in settings else return inputted expansion.
        :param expansion: Expansion key
        :return: Whole expansion
        """

        for func, func_expansion, _ in EXPRESSION_EXPANSIONS:
            if func == expansion:
                return func_expansion
        return expansion

    @pyqtSlot(str, bool, result=str)
    def expandExpression(self, expansion: str, expand_around_current_word: bool) -> str:
        """
        :param expansion: String to expand
        :param expand_around_current_word: If set to True, then exand around current word
        :return: Expanded expansion
        """

        _, _, selected_text = self._get_selection()
        if not selected_text and expand_around_current_word:
            selected_text = self.currentWord().replace("\\", "")

        expansion_type = self.expansionType(expansion)
        expansion = self.getExpansion(expansion)

        if expansion_type != Expansion.ExpansionType.BracketsPack:
            return expansion

        borders = self._currentWordBorders()
        content = self._get_content()

        if borders["end"] == -1 and not selected_text:
            return "{}()".format(expansion)

        for i in range(borders["end"], len(content)):
            current_char = content[i]

            if current_char == "(":
                return expansion
            if not current_char.isspace():
                break

        if selected_text:
            return "{}({})".format(expansion, selected_text)
        else:
            return "{}()".format(expansion)

    @pyqtSlot(result=QVariant)
    def currentWordBorders(self) -> QVariant:
        return QVariant(self._currentWordBorders())

    def _currentWordBorders(self) -> Dict[str, int]:
        """
        :return: Current word start and end
        """

        content = self._get_content()
        cursor = self._get_cursor()
        word_start = 0
        word_end = len(content)

        if self._get_cursor() == 0:
            return {"start": -1, "end": -1}

        splitter_positions = list()
        for splitter in EXPRESSION_SPLITTERS:
            splitter_positions.extend([i for i, letter in enumerate(content) if letter == splitter])

        left_splitters_pos = list(filter(lambda x: x < cursor, splitter_positions))
        right_splitters_pos = list(filter(lambda x: x >= cursor, splitter_positions))

        if left_splitters_pos:
            word_start = min(left_splitters_pos, key=lambda x: abs(x - cursor)) + 1
        if right_splitters_pos:
            word_end = min(right_splitters_pos, key=lambda x: abs(x - cursor))

        word = content[word_start:word_end:].strip()

        if word:
            if self._get_cursor() != word_end:
                brackets_behind_cursor = re.search(
                    '\)*',
                    self._get_content()[self._get_cursor()::]
                ).group()

                word_end -= len(brackets_behind_cursor)

        return {"start": word_start, "end": word_end}

    @pyqtSlot(result=str)
    def currentWord(self) -> str:
        """
        According to cursor in text it determines current word which is edited
        :return: Current word
        """
        content = self._get_content()
        borders = self._currentWordBorders()

        if borders["start"] != -1 and borders["end"] != -1:
            word = content[borders["start"]:borders["end"]:].strip()

            return re.escape(word)
        return ""

    @pyqtProperty(QQuickItem)
    def target(self) -> QQuickItem:
        return self._target

    @target.setter
    def target(self, v: QQuickItem) -> None:
        if self._target != v:
            self._target = v
            self.targetChanged.emit(v)
