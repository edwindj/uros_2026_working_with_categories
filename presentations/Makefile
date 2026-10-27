DOC=01-introduction


${DOC}.pdf: ${DOC}.tex
	latexmk -xelatex ${DOC}.tex

watch:
	latexmk -xelatex -latexoption="-interaction=batchmode" -f -pvc ${DOC}.tex

clean:
	latexmk -xelatex -f -C ${DOC}.tex

tidy:
	latexmk -xelatex -f -c ${DOC}.tex
