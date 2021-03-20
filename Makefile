.ONESHELL:

clean:
	rm -rf *.c *.pyc *.perl.txt *.python.txt commonlog.txt perlog.txt pylog.txt perbclog.txt averlogPerl.txt averlogPython.txt paslex
	cd python
	rm -rf *.c *.pyc *.perl.txt *.python.txt commonlog.txt perlog.txt pylog.txt perbclog.txt averlogPerl.txt averlogPython.txt paslex
	cd __pycache__
	rm -rf *.c *.pyc *.perl.txt *.python.txt commonlog.txt perlog.txt pylog.txt perbclog.txt averlogPerl.txt averlogPython.txt paslex
	cd ../../perl
	rm -rf *.c *.pyc *.perl.txt *.python.txt commonlog.txt perlog.txt pylog.txt perbclog.txt averlogPerl.txt averlogPython.txt paslex