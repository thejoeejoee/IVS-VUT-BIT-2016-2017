# coding=utf-8
from pprint import pformat

from calculator.core.calculator import Calculator

calculator = Calculator()

try:
    import readline
 
__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"
except ImportError:
    pass


def main():
    while True:
        user_input = input('>>> ').strip()
        if not user_input:
            continue
        try:
            result, variables = calculator.process(user_input)
            print(" === {}\n === {}\n".format(result, pformat(dict(variables))))
        except Exception as e:
            print(e, repr(e))


if __name__ == '__main__':
    main()