# Makefile
# Requires asciidoc (>= 8.6) to build the man page

PREFIX=/usr



help:
	@echo "... clean"
	@echo "... install"
	@echo "... man"
	@echo "... uninstall"



clean:
	rm -f *.xml *.8 *.gz



install: man
	install -D -m0644 package-deep-cleanup.8.gz  $(PREFIX)/share/man/man8
	install -D -m0755 package-deep-cleanup.py    $(PREFIX)/bin/package-deep-cleanup



man:
	a2x -f manpage package-deep-cleanup.8.txt
	gzip -9 package-deep-cleanup.8



uninstall:
	rm -f $(PREFIX)/share/man/man8/package-deep-cleanup.8.gz
	rm -f $(PREFIX)/bin/package-deep-cleanup
