# coding=utf-8
from PyQt5.QtQml import qmlRegisterType


class TypeRegister():
    @staticmethod
    def register_type(cls):
        cls_name = cls.__name__
        qmlRegisterType(cls, cls_name, 1, 0, cls_name)