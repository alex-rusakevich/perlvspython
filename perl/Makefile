clres:
	rm -rf ../*.pas.txt

test:
	perl paslex.t

runf:
	perl -e "require './paslex.pl'; lex_file(\"../$(file)\");"

runa:
	for number in 1 2 3; do\
		perl -e "require './paslex.pl'; lex_file(\"../prog$$number.pas\");" ; \
	done