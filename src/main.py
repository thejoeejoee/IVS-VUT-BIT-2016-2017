#!/usr/bin/env python3
# coding=utf-8

import sys
from fileinput import input

from calculator.core.standard_deviation import main as sd_main

sys._excepthook = sys.excepthook
def exception_hook(exctype, value, traceback):
    sys._excepthook(exctype, value, traceback)
sys.excepthook = exception_hook

if __name__ == "__main__":
    if len(sys.argv) > 1 and (sys.argv[1] == '-sd' or sys.argv[1] == '--standard-deviation'):
        exit(sd_main(input(files=sys.argv[2] if len(sys.argv) > 2 else '-')))

    from calculator.ui.app import CalculatorApp
    app = CalculatorApp(sys.argv)

    sys.exit(app.run())
