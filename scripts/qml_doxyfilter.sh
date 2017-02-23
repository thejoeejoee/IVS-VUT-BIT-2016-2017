#!/bin/bash
/usr/bin/env python3 -m doxyqml.doxyqml $1 | sed -e 's/public \w*\./public /ig'
# strips namespace of parent class