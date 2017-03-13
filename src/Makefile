PYTHON=python3

install: install-python install-deps

install-python:
	- apt-get install python3.5 python3.5-venv python3-pip

compile-qt-rcc:
	- pyrcc5 -o calculator/ui/resources.py calculator/ui/qml.qrc

install-deps:
	- pip install -r ../requirements.txt

test:
	- $(PYTHON) test.py || true

run:
	- $(PYTHON) main.py