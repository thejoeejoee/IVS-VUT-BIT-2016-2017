#!/usr/bin/env python3
# coding=utf-8
# TODO main script for start of calculator

import sys

from PyQt5.QtGui import QGuiApplication

from calculator.ui import CalculatorWindow


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)

    view = CalculatorWindow()
    view.show()

    sys.exit(app.exec())