# coding=utf-8
from pprint import pformat

from calculator.core.calculator import Calculator

__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"

calculator = Calculator()

try:
    import readline
except ImportError as e:
    pass


def main():
    try:
        while True:
            user_inputs = input('>>> ').strip().split(";")
            if not user_inputs:
                continue
            try:
                for user_input in user_inputs:
                    result, variables = calculator.process(user_input)
                    print(" === {}\n === {}\n".format(result, pformat(dict(variables))))
            except Exception as e:
                print(e, repr(e))
    except (SystemExit, KeyboardInterrupt, EOFError) as e:
        pass


if __name__ == '__main__':
    main()
