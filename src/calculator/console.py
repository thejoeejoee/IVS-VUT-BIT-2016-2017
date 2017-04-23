# coding=utf-8
from pprint import pformat

from calculator.core.calculator import Calculator

__author__ = "Josef Kolář, Martin Omacht"
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
            user_inputs = input('>>> ').split(";")
            if not user_inputs:
                continue
            try:
                for user_input in user_inputs:
                    user_input = user_input.strip()

                    if user_input.startswith("%print"):
                        _, variables = calculator.process(" ")
                        user_input = user_input.split();
                        if len(user_input) == 2:
                            # print specific variable
                            if user_input[1] in variables:
                                value, src_expr, _ = variables[user_input[1]]
                                print(" {:>4} === {}  ({})\n".format(user_input[1], value, src_expr))
                            else:
                                print("Variable '{}' does not exist.\n".format(user_input[1]))
                        elif len(user_input) == 1:
                            # print all variables
                            for key, value in variables.items():
                                print(" {:>4} === {}  ({})".format(key, value[0], value[1]))
                            print("")
                        else:
                            print("Error: Unexpected number of parameters {}, expected 0 or 1.\n".format(len(user_input) - 1))
                    else:
                        result, _ = calculator.process(user_input)
                        if result is not None:
                            print("=== {}\n".format(result))
            except Exception as e:
                print(e)
    except (SystemExit, KeyboardInterrupt, EOFError) as e:
        print("")


if __name__ == '__main__':
    main()
