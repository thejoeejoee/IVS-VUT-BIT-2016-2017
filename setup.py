# coding=utf-8
from distutils.core import setup

from setuptools import find_packages


def install_requires():
    with open('requirements.txt') as f:
        return f.readlines()


setup(
    name='MathCalculatorDejUranDom',
    version='0.1',
    license='GNU GENERAL PUBLIC LICENSE Version 3',
    long_description=open('README.md').read(),
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
    author_email='xkolar71@stud.fit.vutbr.cz, xnguye16@stud.fit.vutbr.cz, xomach00@stud.fit.vutbr.cz, xnavra61@stud.fit.vutbr.cz',
    keywords='calculator expression mathematics',
    packages=find_packages(where='calculator', exclude=['tests']),
    install_requires=install_requires()
)
