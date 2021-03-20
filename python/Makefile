.PHONY: clres time tentimes runa

clres:
	rm -rf ../*.python.txt pylog.txt

runf:
	python3 pylex.py ../$(file)

runa:
	for n in 3; do\
		python3 pylex.py ../prog$$n.pas; \
	done

time:
	/usr/bin/time -ap -o pylog.txt make runa
	echo "" >> pylog.txt

times:
	for n in `seq 1 $(n)`;\
	do\
		make time;\
	done
