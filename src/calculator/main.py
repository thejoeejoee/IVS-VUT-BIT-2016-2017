#!/usr/bin/env python3
# coding=utf-8

import sys
from fileinput import input
from glob import iglob
from itertools import chain
from os import W_OK, access
from os.path import exists, getmtime, abspath, dirname, join

# definitive solution for calculator imports - due running from non standard working directories
base_path = abspath(dirname(__file__))
sys.path.insert(0, join(base_path, '..'))

QRC_FILE = abspath(join(base_path, './ui/qml.qrc'))
RESOURCES_FILE = abspath(join(base_path, './ui/resources.py'))


def main():
    if len(sys.argv) > 1 and sys.argv[1] in {'-sd', '--standard-deviation'}:
        from calculator.standard_deviation import main as sd_main
        sys.exit(sd_main(
            # file from first parameter if given else std input
            input(files=sys.argv[2] if len(sys.argv) > 2 else '-')
        ))

    if not update_qrc():
        print('Application cannot be started due problems with resources file.')
        sys.exit(1)

    # local import due to resources.py
    from calculator.ui.app import CalculatorApp
    app = CalculatorApp(sys.argv)

    sys.exit(app.run())


def update_qrc():
    """
    Conditionally updates the qrc file from QML and dependent resources.
    :return: True, if file was successfully updated or update is not required, else None
    """
    file_types = 'qml qrc js ttf otf svg qm png'.split()

    last_modification = max(
        map(
            getmtime,
            chain(
                *(
                    file_ for file_ in (
                    iglob(join(
                        abspath(dirname(__file__)),
                        '{base_path}/**/*.{file_type}'.format(
                            file_type=file_type,
                            base_path=base_path)
                    ), recursive=True
                    ) for file_type in file_types)
                )
            )
        )
    )

    if exists(RESOURCES_FILE) and (last_modification - getmtime(RESOURCES_FILE)) < 2:
        return True

    if exists(RESOURCES_FILE) and not access(RESOURCES_FILE, W_OK):
        print('Resources file {} is outdated.'.format(
            RESOURCES_FILE
        ), file=sys.stderr)
        return True

    print('Change in UI files detected, recompiling resources.py...', file=sys.stderr)
    if not access(RESOURCES_FILE, W_OK):
        print('Resources file {} is not exist and is not writable, please call with write permissions.'.format(
            RESOURCES_FILE
        ), file=sys.stderr)
        return False

    from PyQt5.pyrcc_main import processResourceFile
    if processResourceFile([QRC_FILE], RESOURCES_FILE, False):
        print('Resources.py successfully recompiled.', file=sys.stderr)
        return True

    print('Problem with compiling resources.py.', file=sys.stderr)


if __name__ == "__main__":
    main()
