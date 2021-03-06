# IVS-VUT-BIT-2016-2017

[![Build Status](https://travis-ci.com/thejoeejoee/IVS-VUT-BIT-2016-2017.svg?token=MqEeDyeLfZw3xFmAVUzV&branch=develop)](https://travis-ci.com/thejoeejoee/IVS-VUT-BIT-2016-2017)
[![Codeship](https://img.shields.io/codeship/a2ac7ad0-fb4b-0134-7062-02a6a40c3d5e.svg)](https://app.codeship.com/projects/211472)
[![codecov](https://img.shields.io/codecov/c/token/M5EwaVLlg7/github/thejoeejoee/IVS-VUT-BIT-2016-2017/develop.svg)](https://codecov.io/gh/thejoeejoee/IVS-VUT-BIT-2016-2017)
[![License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

![logo](./doc/logo.png)

Grafická kalkulačka jako školní projekt do předmětu IVS na FIT VUT v letním semestru školního roku 2016/2017. Kalkulačka nabízí plnohodnotné matematické funkce, systém proměnných (včetně jejich zavislostí) i skrytý easter egg.

Rozhraní kalkulačky
-------------------
![Screenshot](./screenshot.png)

Vývoj
-----
Na jádro kalkulačky je napsána sada jednotkových testů. Na tyto testy existuje spouštěcí skript `src/test.py` nebo je lze spustit ze složky `src/` pomocí utility `make`:
```
make test
```

Po každé aplikované změně v repozitáži se aplikace sestaví a otestuje pomocí systémů [Travis-CI](https://travis-ci.com/thejoeejoee/IVS-VUT-BIT-2016-2017) a [Codeship](https://app.codeship.com/projects/211472).
Pomocí příkazu `make` lze také zkompilovat QML a přiložené zdroje, či nainstalovat závislosti aplikace viz. **cíl `help`**.

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
