#!/usr/bin/env python3
# coding=utf-8
import unittest
from os.path import dirname

try:
    from colour_runner.runner import ColourTextTestRunner as TestRunner
    # ColourTextTestRunner needs installed curses, which may be problem on Windows based systems
except ImportError:
    # fallback to default text test runner
    from unittest import TextTestRunner as TestRunner


from tests import calculator


def main():
    loader = unittest.TestLoader()

    suite = loader.discover(dirname(calculator.__file__), pattern='*.py')
    runner = TestRunner(verbosity=10)
    result = runner.run(unittest.TestSuite(suite))

    exit(len(result.errors + result.failures))


if __name__ == '__main__':
    main()
