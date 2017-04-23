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


def process_user_input(user_input):
    user_input = user_input.strip()
    if user_input.startswith("%"):
        user_input = user_input.split()
        process_command(user_input[0], user_input[1:])
    else:
        result, _ = calculator.process(user_input)
        if result is not None:
            print("=== {}\n".format(result))


def process_command(cmd, args):
    if cmd == "%print":
        _, variables = calculator.process(" ")
        if len(args) == 1:
            # print specific variable
            if args[0] in variables:
                value, src_expr, _ = variables[args[0]]
                print(" {:>4} === {}  ({})\n".format(args[0], value, src_expr))
            else:
                raise Exception("Variable '{}' does not exist.\n".format(args[0]))
        elif len(args) == 0:
            # print all variables
            for key, value in variables.items():
                print(" {:>4} === {}  ({})".format(key, value[0], value[1]))
            print("")
        else:
            raise Exception("Unexpected number of parameters {}, expected 0 or 1.\n".format(len(user_input) - 1))
    else:
        raise Exception("Unknown command.");


def main():
    try:
        while True:
            user_inputs = input('>>> ').split(";")
            if not user_inputs:
                continue
            try:
                for user_input in user_inputs:
                    process_user_input(user_input)
            except Exception as e:
                print("Error: {}".format(repr(e)))
    except (SystemExit, KeyboardInterrupt, EOFError) as e:
        print("")


if __name__ == '__main__':
    main()
