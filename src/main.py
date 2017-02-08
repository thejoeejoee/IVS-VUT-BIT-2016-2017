#!/usr/bin/env python3
# coding=utf-8
# TODO main script for start of calculator

import sys

from calculator.ui.app import CalculatorApp


if __name__ == "__main__":
    app = CalculatorApp(sys.argv)

    sys.exit(app.run())