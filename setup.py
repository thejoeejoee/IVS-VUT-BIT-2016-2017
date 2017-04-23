# coding=utf-8


from distutils import core
from os.path import abspath, dirname, join

from setuptools import find_packages
from setuptools.command.sdist import sdist

__author__ = "Josef Kolář, Son Hai Nguyen"
__copyright__ = "Copyright 2017, /dej/uran/dom team"
__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]
__license__ = "GNU GPL Version 3"

base_path = abspath(dirname(__file__))


class SDistCommand(sdist):
    def run(self):
        try:
            from calculator.main import update_qrc
        except ImportError:
            def update_qrc():
                pass

        update_qrc()
        return super().run()


def setup():
    core.setup(
        name='calculator',
        version='1.0rc1',
        license='GNU GENERAL PUBLIC LICENSE Version 3',
        long_description=open(join(base_path, 'README.md')).read(),
        url='https://github.com/thejoeejoee/IVS-VUT-BIT-2016-2017',
        classifiers=[
            'Development Status :: 3 - Alpha',
            'Environment :: X11 Applications :: Qt',
            'License :: OSI Approved :: GNU Lesser General Public License v3 (LGPLv3)',
            'Programming Language :: Python :: 3.5',
            'Programming Language :: Python :: 3.6',
            'Programming Language :: Python :: 3 :: Only',
            'Topic :: Scientific/Engineering :: Mathematics',
            'Topic :: Utilities'
        ],
        author='Josef Kolar, Son Hai Nguyen, Martin Omacht, Robert Navratil',
        author_email='xkolar71@stud.fit.vutbr.cz, xnguye16@stud.fit.vutbr.cz,'
                     'xomach00@stud.fit.vutbr.cz, xnavra61@stud.fit.vutbr.cz',
        keywords='calculator expression mathematics',
        packages=find_packages('src', exclude=["*.tests", "*.tests.*", "tests.*", "tests"]),
        install_requires=[
            'PyOpenGL',
            'PyQt5==5.7.1',
        ],
        requires=[
            'colour_runner',
            'termcolor',
            'stdeb',
            'doxypypy',
            'doxyqml',
        ],
        package_dir={'': 'src/'},
        entry_points={
            'console_scripts': [
                'calculator-console=calculator.console:main',
                'calculator=calculator.main:main',
            ]
        },
        data_files=[
            ('share/icons/hicolor/scalable/apps', ['data/calculator.svg']),
            ('share/applications', ['data/calculator.desktop'])
        ],
        include_package_data=True,
        test_suite='tests',
        cmdclass={
            'sdist': SDistCommand,
        },
    )


if __name__ == '__main__':
    setup()
