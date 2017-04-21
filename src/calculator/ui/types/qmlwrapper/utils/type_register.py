# coding=utf-8
from PyQt5.QtQml import qmlRegisterType
 
__author__ = "Son Hai Nguyen"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class TypeRegister():
    @staticmethod
    def register_type(cls):
        cls_name = cls.__name__
        qmlRegisterType(cls, cls_name, 1, 0, cls_name)