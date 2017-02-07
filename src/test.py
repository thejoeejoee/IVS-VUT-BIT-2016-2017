#!/usr/bin/env python3
# coding=utf-8
import unittest
from os.path import dirname

from tests import calculator


def main():
    loader = unittest.TestLoader()

    suite = loader.discover(dirname(calculator.__file__), pattern='*.py')
    result = unittest.TextTestRunner(verbosity=10).run(unittest.TestSuite(suite))

    exit(len(result.errors + result.failures))


if __name__ == '__main__':
    main()
