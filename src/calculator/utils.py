# coding=utf-8
from functools import update_wrapper, singledispatch


def method_single_dispatch(func):
    """
    Decorator like single dispatch, but works with instance methods.
    :param func: function to decorate
    :return: decorated function
    """
    dispatcher = singledispatch(func)

    def wrapper(*args, **kw):
        # index 1, because 0 is instance itself
        return dispatcher.dispatch(args[1].__class__)(*args, **kw)

    wrapper.register = dispatcher.register
    update_wrapper(wrapper, func)
    return wrapper
