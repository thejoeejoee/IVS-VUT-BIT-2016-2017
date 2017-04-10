# coding=utf-8


from distutils import core
from os.path import abspath, dirname, join

from setuptools import find_packages

base_path = abspath(dirname(__file__))


def setup():
    core.setup(
        name='calculator',
        version='0.2',
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
            'PyQt5'
        ],
        requires=[
            'colour_runner',
            'termcolor',
            'stdeb',
            'doxypy',
            'doxyqml',
        ],
        package_dir={'': 'src/'},
        entry_points={
            'console_scripts': [
                'calculator-console=calculator.console:main',
                'calculator-app=calculator.main:main',
            ]
        },
        include_package_data=True,
        test_suite='tests',
    )


if __name__ == '__main__':
    setup()
