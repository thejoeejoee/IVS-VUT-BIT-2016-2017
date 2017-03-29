REQUIREMENTS=../requirements.txt

ifdef ENVIROMENT
     ENVIROMENT:=$(shell echo $(ENVIROMENT) | tr a-z A-Z)
else
     ENVIROMENT=$(shell if [ "${VIRTUAL_ENV}" != "" ] > /dev/null; then echo LOCAL; else echo GLOBAL; fi)
endif

GLOBAL_PYTHON=python3
GLOBAL_PIP=pip3
GLOBAL_PYRCC5=pyrcc5

VENV_PATH=../.venv
LOCAL_PYTHON=$(VENV_PATH)/bin/$(GLOBAL_PYTHON)
LOCAL_PIP=$(VENV_PATH)/bin/$(GLOBAL_PIP)
LOCAL_PYRCC5=$(VENV_PATH)/bin/$(GLOBAL_PYRCC5)

PYTHON=$(ENVIROMENT)_PYTHON

all: run

LOCAL:
	@touch $(VENV_PATH) || pyvenv $(VENV_PATH)
	$(info ***** Using LOCAL enviroment with python $(abspath $($(PYTHON))). *****)

GLOBAL:
	$(info ***** Using SYSTEM enviroment with python $(shell which $($(PYTHON))). *****)

# .PHONY: install $(ENVIROMENT) install-python install-calculator test run

install: install-python $(ENVIROMENT) install-calculator

install-python:
	@if ! dpkg -s python3.5 > /dev/null && dpkg -s python3-pip > /dev/null; then\
		apt-get update && apt-get -y install python3.5 python3-pip python3-venv;\
	fi
	pip3 install --upgrade pip > /dev/null

install-calculator: $(ENVIROMENT)
	$($(PYTHON)) ../setup.py install

test: $(ENVIROMENT)
	$($(PYTHON)) test.py || true

run: $(ENVIROMENT)
	$($(PYTHON)) calculator/main.py
