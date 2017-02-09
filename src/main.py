#!/usr/bin/env python3
# coding=utf-8
# TODO main script for start of calculator

import sys

from calculator.ui.app import CalculatorApp

sys._excepthook = sys.excepthook
def exception_hook(exctype, value, traceback):
    sys._excepthook(exctype, value, traceback)
sys.excepthook = exception_hook

if __name__ == "__main__":
    app = CalculatorApp(sys.argv)

    sys.exit(app.run())