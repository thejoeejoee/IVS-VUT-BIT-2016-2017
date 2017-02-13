#!/usr/bin/env python3
# coding=utf-8
import unittest
from os.path import dirname

from tests import calculator

try:
    from colour_runner.runner import ColourTextTestRunner as TestRunner
    # ColourTextTestRunner needs installed curses, which may be problem on Windows based systems
except ImportError:
    # fallback to default text test runner
    from unittest import TextTestRunner as TestRunner



def load_tests(loader: unittest.TestLoader, suite: unittest.TestSuite, pattern='*.py'):
    loader = unittest.TestLoader()
    suite = loader.discover(dirname(calculator.__file__), pattern='*.py')
    return unittest.TestSuite(suite)


def main():
    runner = TestRunner(verbosity=10)
    result = runner.run(load_tests())
    exit(len(result.errors + result.failures))


if __name__ == '__main__':
    main()
