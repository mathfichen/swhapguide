# Depends: rubber
MDS = $(wildcard *.md)
TEXS = $(patsubst %.md,%.tex,$(MDS))
PDFS = $(patsubst %.md,%.pdf,$(MDS))
MAIN = swhap@inria

all: $(MAIN).pdf

.PRECIOUS: $(TEXS)

%.tex: %.md
	pandoc -s $< -f markdown+fenced_code_blocks+fenced_code_attributes+pipe_tables -t latex --template=swhap-template.latex -H swhapguide-header.tex --filter pandoc-xnos --listings --toc --biblatex --bibliography=swhap.bib -o $@

%.pdf: %.tex
ifeq (, $(shell PATH=$(PATH) which rubber))
	echo "No rubber in $(PATH), falling back to basic pdflatex calls"
	pdflatex $<
	biber $*
	pdflatex $<
else
	rubber -m pdftex $<
endif

clean: $(patsubst %,%/clean,$(TEXS))

%/clean:
	if [ -f $* ]; then rubber -m pdftex --clean $* ; fi
	rm -f $*

distclean: clean
