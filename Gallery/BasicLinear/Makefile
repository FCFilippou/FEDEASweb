README.md: *.m index.py
	./index.py > README.md

pdf: README.md
	pandoc README.md -o Index.pdf \
	-V geometry:"margin=1in" \
	-V colorlinks \
