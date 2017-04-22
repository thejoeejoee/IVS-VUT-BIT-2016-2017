REQUIREMENTS=../requirements.txt
PACK_NAME=xkolar71_xnguye16_xomach00_xnavra61
PYTHON=python3
PIP=pip3
PYRCC5=pyrcc5
DIR:=$(CURDIR)

TMP_DIR := $(shell mktemp -d)

all: run

.PHONY: install install-python install-calculator install-requirements test run clean doc\
		compile-resources run pack-deb clean-pyc build-profiling-report

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

.ONESHELL:
pack: build-profiling-report clean
	mkdir -p $(TMP_DIR)/$(PACK_NAME)/doc $(TMP_DIR)/$(PACK_NAME)/install $(TMP_DIR)/$(PACK_NAME)/repo;
	cp -R ./../ $(TMP_DIR)/$(PACK_NAME)/repo/
	rm -rf $(TMP_DIR)/$(PACK_NAME)/repo/.venv $(TMP_DIR)/$(PACK_NAME)/repo/.idea;
	make doc
	cp -r ../doc/html/* $(TMP_DIR)/$(PACK_NAME)/doc/;
	make pack-deb
	cp ../deb_dist/*.deb $(TMP_DIR)/$(PACK_NAME)/install/;
	cd $(TMP_DIR);
	zip -r $(PACK_NAME).zip $(PACK_NAME);
	cd -;
	cp $(TMP_DIR)/$(PACK_NAME).zip ..;

clean:
	rm -rf ../dist/ ../deb_dist/ ./calculator.egg-info/ ../$(PACK_NAME).zip ../build ../calculator.egg-info/
	find ../profiling/ -maxdepth 1 -type f ! -name "*.pdf" ! -name "*.tex" -delete

pack-deb: clean clean-pyc compile-resources
	cd ..; $(PYTHON) setup.py --command-packages=stdeb.command bdist_deb

clean-pyc:
	find . -name "*.pyc" -delete

compile-resources:
	$(PYRCC5) -o calculator/ui/resources.py calculator/ui/qml.qrc

doc:
	doxygen

build-user-documentation:
	cd ../doc && pdflatex documentation.tex && pdflatex documentation.tex pdflatex
	
build-profiling-report: ../profiling/report.tex
	cd ../profiling/; pdflatex -interaction nonstopmode report.tex
