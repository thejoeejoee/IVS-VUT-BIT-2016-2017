# IVS-VUT-BIT-2016-2017

[![Build Status](https://travis-ci.com/thejoeejoee/IVS-VUT-BIT-2016-2017.svg?token=MqEeDyeLfZw3xFmAVUzV&branch=develop)](https://travis-ci.com/thejoeejoee/IVS-VUT-BIT-2016-2017)
[![Codeship](https://img.shields.io/codeship/a2ac7ad0-fb4b-0134-7062-02a6a40c3d5e.svg)](https://app.codeship.com/projects/211472)
[![codecov](https://img.shields.io/codecov/c/token/M5EwaVLlg7/github/thejoeejoee/IVS-VUT-BIT-2016-2017/develop.svg)](https://codecov.io/gh/thejoeejoee/IVS-VUT-BIT-2016-2017)
[![License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

Grafická kalkulačka jako školní projekt do předmětu IVS na FIT VUT v letním semestru školního roku 2016/2017. Kalkulačka nabízí plnohodnotné matematické funkce, systém proměnných (včetně jejich zavislostí) i skrytý easter egg.

Instalace
---------
Aplikaci je možnost nainstalovat buď jako instalační balíček operačního systému Debian stáhnutelný z [posledního vydání](https://github.com/thejoeejoee/IVS-VUT-BIT-2016-2017/releases/latest) aplikace: Instalace pak probíhá následovně:
```
// instalace balíku
# dpkg -i python3-calculator_XXX.deb
// doinstalace jeho závislostí
# apt install -f
```
Alternativní cestou instalace je instalace jako standardní balíček jazyka Python pomocí skriptu `setup.py` v kořenu repozitáře aplikace:
```
$ git clone https://github.com/thejoeejoee/IVS-VUT-BIT-2016-2017.git calculator
$ cd calculator
$ python3 setup.py install
```
V obou případech je do systému nainstalována grafický spouštěč, hledejte v menu vašeho systému. Také jsou nainstalovány spustitelné programy `calculator-app`, `calculator-console`, z niž první spouští grafické rozhraní aplikace, druhý pouze konzolovou verzi kalkulačky. 

Prostředí
---------
Ubuntu 64bit

Autoři
------

/dej/uran/dom
- xkolar71 Josef Kolář
- xnguye16 Son Hai Nguyen
- xomach00 Martin Omacht
- xnavra61 Robert Navrátil

Licence
-------

Tento program je licenován pod licencí GNU GPL Version 3.
