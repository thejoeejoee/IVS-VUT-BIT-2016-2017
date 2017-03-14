
VENV=../.venv
REQUIREMENTS=../requirements.txt
VENV_ACTIVATE=$(VENV)/bin/activate
PYTHON="$(VENV)/bin/python"
PIP="$(VENV)/bin/pip"
PYRCC5="$(VENV)/bin/pyrcc5"

install: install-python venv

install-python:
	- apt-get install python3.5 python3.5-venv python3-pip

compile-qt-rcc: venv
	- $(PYRCC5) -o calculator/ui/resources.py calculator/ui/qml.qrc

test: venv
	- $(PYTHON) test.py || true

run: venv
	- $(PYTHON) main.py

venv: $(REQUIREMENTS)
	test -d $(VENV) || virtualenv $(VENV)
	$(PIP) install -Ur ../requirements.txt
	touch $(VENV_ACTIVATE)
