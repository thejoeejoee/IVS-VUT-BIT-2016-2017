# coding=utf-8
from pprint import pformat

from calculator.core.calculator import Calculator

calculator = Calculator()

try:
    import readline
except ImportError:
    pass

while True:
    user_input = input('>>> ').strip()
    if not user_input:
        continue
    try:
        result, variables = calculator.process(user_input)
        print(" === {}\n === {}\n".format(result, pformat(dict(variables))))
    except Exception as e:
        print(e, repr(e))
