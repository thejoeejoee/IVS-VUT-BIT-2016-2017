FILENAME=dokumentace

all: $(FILENAME).tex
	pdflatex $<
	pdflatex $<

clean: $(FILENAME).aux $(FILENAME).log $(FILENAME).toc $(FILENAME).out $(FILENAME).pdf
	rm -f $^
