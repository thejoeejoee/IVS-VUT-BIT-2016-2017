# coding=utf-8


from distutils import core
from distutils.command.install import install
from unittest.mock import patch

from setuptools import find_packages


def install_requires():
    with open('requirements.txt') as f:
        return [line.strip().split('#')[0] for line in f.readlines() if line.strip()]


class CalculatorInstallation(install):
    def run(self):
        super(CalculatorInstallation, self).run()

        with patch('sys.argv', ['', '-o', 'src/calculator/ui/resources.py', 'src/calculator/ui/qml.qrc']):
            from PyQt5.pyrcc_main import main
            main()


def setup():
    core.setup(
        name='calculator',
        version='0.1',
        license='GNU GENERAL PUBLIC LICENSE Version 3',
        # long_description=open('./README.md').read(),
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
        install_requires=install_requires() + [
            'PyOpenGL #;"Debian" in platform_version or "Ubuntu" in platform_version'
        ],
        package_dir={'': 'src'},
        entry_points={
            'console_scripts': [
                'calculator-console=calculator.console:main',
                'calculator-app=calculator.main:main',
            ]
        },
        # include_package_data=True,
        cmdclass=dict(
            install=CalculatorInstallation
        ),
        test_suite='tests',
    )


if __name__ == '__main__':
    setup()
