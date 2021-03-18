.PHONY: clres time tentimes runa

clres:
	rm -rf ../*.perl.txt perlog.txt

test:
	perl paslex.t

runf:
	perl -e "require './paslex.pl'; lex_file(\"../$(file)\");"

runa:
	for number in 1 2 3; do\
		perl -e "require './paslex.pl'; lex_file(\"../prog$$number.pas\");"; \
	done

time:
	/usr/bin/time -ap -o perlog.txt make runa
	echo "" >> perlog.txt

times:
	for n in `seq 1 $(n)`;\
	do\
		make time;\
	done
