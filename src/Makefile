
REQUIREMENTS=../requirements.txt

VENV=true

ifdef VENV
 VENV=../.venv
 VENV_ACTIVATE=$(VENV)/bin/activate
 PYTHON="$(VENV)/bin/python"
 PIP="$(VENV)/bin/pip"
 PYRCC5="$(VENV)/bin/pyrcc5"
else
 PYTHON="python3"
 PIP="pip3"
 PYRCC5="pyrcc5"
endif


install: install-python venv install-calculator

install-python:
	apt-get update && apt-get -y install python3.5 python3-pip python3-venv && pip3 install --upgrade pip

install-calculator:
	$(PYTHON) ../setup.py install

compile-qt-rcc: venv
	$(PYRCC5) -o calculator/ui/resources.py calculator/ui/qml.qrc

test: venv
	$(PYTHON) test.py || true

run: venv compile-qt-rcc
	$(PYTHON) calculator/main.py

venv: $(REQUIREMENTS)
ifdef VENV
	test -d $(VENV) || pyvenv $(VENV)
	$(PIP) install -Ur ../requirements.txt
	touch $(VENV_ACTIVATE)
endif
