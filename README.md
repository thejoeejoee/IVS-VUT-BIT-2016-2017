# IVS-VUT-BIT-2016-2017

[![Build Status](https://travis-ci.com/thejoeejoee/IVS-VUT-BIT-2016-2017.svg?token=MqEeDyeLfZw3xFmAVUzV&branch=develop)](https://travis-ci.com/thejoeejoee/IVS-VUT-BIT-2016-2017)
[![Codeship](https://img.shields.io/codeship/a2ac7ad0-fb4b-0134-7062-02a6a40c3d5e.svg)](https://app.codeship.com/projects/211472)
[![codecov](https://img.shields.io/codecov/c/token/M5EwaVLlg7/github/thejoeejoee/IVS-VUT-BIT-2016-2017/develop.svg)](https://codecov.io/gh/thejoeejoee/IVS-VUT-BIT-2016-2017)
[![License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)

Grafická kalkulačka jako školní projekt do předmětu IVS na FIT VUT v letním semestru školního roku 2016/2017. Kalkulačka nabízí plnohodnotné matematické funkce, systém proměnných (včetně jejich zavislostí) i skrytý easter egg.

Tutoriálem k aplikaci a postupy pro **instalaci** naleznete v [uživatelské dokumentaci](./doc/doc.md).

Rozhraní kalkulačky
-------------------
![Screenshot](./screenshot.png)

Vývoj
-----
Testovací skripty spustíme příkazem
```
make test
```

Po každém commitu se aplikace sestaví a otestuje pomocí systémů [Travis-CI](https://travis-ci.com/) a [Codeship](https://codeship.com/).
Pomocí příkazu `make` lze také zkompilovat QML a přiložené zdroje, či nainstalovat závislosti aplikace viz. Makefile.

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
