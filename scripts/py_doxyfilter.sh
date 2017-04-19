#!/bin/bash
# TODO: use tempfile to generate copy of file, after that rewite with pyment to another docstrings and after that, file could be processed by doxypy
/usr/bin/env python3 -m doxypypy.doxypypy -a -c $1
