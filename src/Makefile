REQUIREMENTS=../requirements.txt

PYTHON=python3
PIP=pip3
PYRCC5=pyrcc5
DIR:=$(CURDIR)

all: run

.PHONY: install install-python install-calculator install-requirements test run clean doc compile-resources run pack-deb clean-pyc

install: install-python install-calculator

install-python:
	@if ! dpkg -s python3.5 > /dev/null && dpkg -s python3-pip > /dev/null; then\
		apt-get update && apt-get -y install python3-all python3.5 python3-pip python3-venv;\
	fi
	pip3 install --upgrade pip > /dev/null

install-calculator:
	cd ..; $(PYTHON) $(DIR)/../setup.py install

install-requirements: install-python
	$(PIP) install -r $(REQUIREMENTS)

test:
	$(PYTHON) $(DIR)/test.py || true

run:
	$(PYTHON) $(DIR)/calculator/main.py

clean:
	rm -rf ../dist/ ../deb_dist/ ./calculator.egg-info/

pack-deb: clean clean-pyc compile-resources
	cd ..; $(PYTHON) setup.py --command-packages=stdeb.command bdist_deb

clean-pyc:
	find . -name "*.pyc" -delete

compile-resources:
	$(PYRCC5) -o calculator/ui/resources.py calculator/ui/qml.qrc

doc:
	doxygen

run: $(ENVIROMENT)
	$($(PYTHON)) calculator/main.py
