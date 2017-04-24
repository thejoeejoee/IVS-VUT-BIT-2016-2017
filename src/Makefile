REQUIREMENTS=../requirements.txt
PACK_NAME=xkolar71_xnguye16_xomach00_xnavra61
PYTHON=python3
PIP=pip3
PYRCC5=pyrcc5
LATEX=pdflatex -interaction nonstopmode 
DIR:=$(CURDIR)
TMP_DIR := $(shell mktemp -d)
IS_FIT_PACK_NAME=IS-FIT_$(PACK_NAME)

all: compile

.PHONY: install install-python install-calculator install-requirements test run clean doc\
		compile-resources run pack-deb clean-pyc build-profiling-report build-user-documentation\
		compile help

install: install-python install-calculator

install-python: ## Install python dependencies for calculator.
	@if ! dpkg -s python3.5 > /dev/null && dpkg -s python3-pip > /dev/null; then\
		apt-get update && apt-get -y install python3-all python3.5 python3-pip python3-venv;\
	fi
	pip3 install --upgrade pip > /dev/null

install-calculator:  ## Install calculator as Python package.
	@cd .. && $(PYTHON) $(DIR)/../setup.py install

install-requirements: ## Manualy install calculator Python dependencies. 
	@$(PIP) install -r $(REQUIREMENTS)

test: ## Run unit tests.
	@$(PYTHON) $(DIR)/test.py

run: ## Run calculator with GUI.
	@$(PYTHON) $(DIR)/calculator/main.py

console: ## Run calculator with textual interface.
	@$(PYTHON) $(DIR)/calculator/console.py

compile: ## Compile project.
	@echo "Nothing to compile in Python project."

.ONESHELL:
pack: build-profiling-report build-user-documentation clean ## Pack archive with repo, doc and installers to distribute Calculator.
	rm -rf $(TMP_DIR)/$(PACK_NAME)/*
	mkdir -p $(TMP_DIR)/$(PACK_NAME)/doc $(TMP_DIR)/$(PACK_NAME)/install $(TMP_DIR)/$(PACK_NAME)/repo
	cp -R ./../ $(TMP_DIR)/$(PACK_NAME)/repo/
	cp $(TMP_DIR)/$(PACK_NAME)/repo/doc/documentation.pdf $(TMP_DIR)/$(PACK_NAME)/repo/documentation.pdf
	rm -rf $(TMP_DIR)/$(PACK_NAME)/repo/.venv $(TMP_DIR)/$(PACK_NAME)/repo/.idea
	make doc
	cp -r ../doc/html/* $(TMP_DIR)/$(PACK_NAME)/doc/
	make pack-deb
	cp ../deb_dist/*.deb $(TMP_DIR)/$(PACK_NAME)/install/
	cd $(TMP_DIR)
	zip -r $(PACK_NAME).zip $(PACK_NAME)
	cd -
	cp $(TMP_DIR)/$(PACK_NAME).zip ..

.ONESHELL:
pack-wis: build-user-documentation clean ## Pack Calculator to submit to IS FIT (with source codes, package metadata and user documentation).
	cd ..
	rm -rf $(TMP_DIR)/$(PACK_NAME)/*
	mkdir -p $(TMP_DIR)/$(PACK_NAME)
	cp -R hodnoceni.txt src/calculator doc/documentation.pdf odevzdani.txt $(TMP_DIR)/$(PACK_NAME)
	cd $(TMP_DIR)
	zip -r IS-FIT_$(PACK_NAME).zip $(PACK_NAME)
	cd -
	cp $(TMP_DIR)/IS-FIT_$(PACK_NAME).zip .

clean: ## Clean all compiled, packed redundant files.
	rm -rf ../dist/ ../deb_dist/ ./calculator.egg-info/ ../$(PACK_NAME).zip ../build ../calculator.egg-info/ ../doc/html ../doc/latex
	find ../profiling/ -maxdepth 1 -type f ! -name "*.pdf" ! -name "*.tex" -delete
	find ../doc/ -maxdepth 1 -type f ! -name "*.png" ! -name "*.tex" ! -name "*.pdf" -delete
	rm -rf ../$(IS_FIT_PACK_NAME).zip ../$(PACK_NAME).zip ../*.tar.gz

pack-deb: clean clean-pyc compile-resources ## Pack Calculator as Debian package.
	cd ..; $(PYTHON) setup.py --command-packages=stdeb.command bdist_deb

clean-pyc: ## Remove all compiles Python files (.pyc).
	find . -name "*.pyc" -delete

compile-resources: ## Compile QML resources into one resources file.
	$(PYRCC5) -o calculator/ui/resources.py calculator/ui/qml.qrc

doc: ## Generate program documentation into /doc folder.
	doxygen

build-user-documentation: ../doc/documentation.tex ## Compile user documentation into /doc/documentation.pdf.
	cd ../doc && $(LATEX) documentation.tex && $(LATEX) documentation.tex && $(LATEX) documentation.tex
	
build-profiling-report: ../profiling/report.tex ## Compile profiling report into /profiling/report.pdf.
	cd ../profiling/ && $(LATEX) report.tex && $(LATEX) report.tex && $(LATEX) report.tex

help: ## Prints help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort |
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-25s\033[0m %s\n", $$1, $$2}'