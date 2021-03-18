.PHONY: clres time tentimes runa

clres:
	rm -rf ../*.perl.txt perlog.txt

test:
	perl paslex.t

runf:
	perl -e "require './paslex.pl'; lex_file(\"../$(file)\");"

runfc:
	./paslex $(file)

runa:
	for number in 1 2 3; do\
		perl -e "require './paslex.pl'; lex_file(\"../prog$$number.pas\");"; \
	done

runac:
	for number in 1 2 3; do\
		./paslex ../prog$$number.pas; \
	done

time:
	/usr/bin/time -ap -o perlog.txt make runa
	echo "" >> perlog.txt

timec:
	/usr/bin/time -ap -o perlog.txt make runac
	echo "" >> perlog.txt

times:
	for n in `seq 1 $(n)`;\
	do\
		make time;\
	done

timesc:
	for n in `seq 1 $(n)`;\
	do\
		make timec;\
	done

compile:
	perl -MO=C,-opaslex.c paslex.pl
	cc_harness -O2 -Duseshrplib -o paslex paslex.c
	strip --strip-all paslex
