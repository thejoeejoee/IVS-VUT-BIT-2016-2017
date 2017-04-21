# coding=utf-8

from ast import Num, AugAssign, Name, Add, Assign
from unittest import TestCase

from calculator.core.parser.transform.aug_assign_restrict import AugAssignRestrictTransform
from calculator.exceptions import SyntaxRestrictError

__author__ = "Josef Kolář"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"


class AugAssignRestrictTransformTest(TestCase):
    def setUp(self):
        self.transform = AugAssignRestrictTransform()

    def test_restrict_aug_assign(self):
        with self.assertRaises(SyntaxRestrictError):
            self.transform.visit(
                AugAssign(target=Name(), op=Add(), value=Num())
            )

    def test_no_restrict_assign(self):
        try:
            self.transform.visit(
                Assign(targets=(Name(),), value=Num())
            )
        except Exception as e:
            self.fail(str(e))
