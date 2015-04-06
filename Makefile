# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

PREFIX =
SYSCONF = /etc
DEV = /dev
BIN = /bin
SBIN = /sbin
DATA = /usr/share
LICENSES = $(DATA)/licenses
COMMAND = got
PKGNAME = gates-of-tartaros
SSH = ssh

SH = bash
SH_SHEBANG = /usr/bin/env $(SH)
ECHO = /usr/bin/echo

EXAMPLES = README lower-left-ponysay allow-uppercase issue-file   \
           commands no-empty-user baudrate cerberus hide-username \
           readline revoke-access



.PHONY: default
default: cmd info

.PHONY: all
all: cmd doc

.PHONY: doc
doc: info pdf ps dvi

obj/gates-of-tartaros.texinfo: info/gates-of-tartaros.texinfo
	mkdir -p obj
	cp "$<" "$@"
	sed -i 's:^@set BIN /bin:@set BIN $(PREFIX)$(BIN):g' "$@"
	sed -i 's:^@set SBIN /sbin:@set SBIN $(PREFIX)$(SBIN):g' "$@"
	sed -i 's:^@set DEV /dev:@set DEV $(DEV):g' "$@"
	sed -i 's:^@set ETC /etc:@set ETC $(SYSCONF):g' "$@"
	sed -i 's:^@set GOT got:@set GOT $(COMMAND):g' "$@"
	sed -i 's:^@set SSH ssh:@set SSH $(SSH):g' "$@"

obj/fdl.texinfo: info/fdl.texinfo
	mkdir -p obj
	cp "$<" "$@"

.PHONY: info
info: gates-of-tartaros.info
%.info: obj/%.texinfo obj/fdl.texinfo
	makeinfo "$<"

.PHONY: pdf
pdf: gates-of-tartaros.pdf
%.pdf: obj/%.texinfo obj/fdl.texinfo
	@mkdir -p obj/pdf
	cd obj/pdf && yes X | texi2pdf "../../$<"
	mv "obj/pdf/$@" "$@"

.PHONY: dvi
dvi: gates-of-tartaros.dvi
%.dvi: obj/%.texinfo obj/fdl.texinfo
	@mkdir -p obj/dvi
	cd obj/dvi && yes X | $(TEXI2DVI) "../../$<"
	mv "obj/dvi/$@" "$@"

.PHONY: ps
ps: gates-of-tartaros.ps
%.ps: obj/%.texinfo obj/fdl.texinfo
	@mkdir -p obj/ps
	cd obj/ps && yes X | texi2pdf --ps "../../$<"
	mv "obj/ps/$@" "$@"

.PHONY: cmd
cmd: got.install

got.install: got
	cp "$<" "$@"
	sed -i 's:#!/usr/bin/env bash:#!$(SH_SHEBANG):g' "$@"
	sed -i 's:@prefix@:$(PREFIX):g' "$@"
	sed -i 's:@dev@:$(DEV):g' "$@"
	sed -i 's:@etc@:$(SYSCONF):g' "$@"
	sed -i 's:@command@:$(COMMAND):g' "$@"
	sed -i 's:@ssh@:$(SSH):g' "$@"
	sed -i 's:@echo@:$(ECHO):g' "$@"



.PHONY: install
install: install-cmd install-info

.PHONY: install
install-all: install-cmd install-doc

.PHONY: install-cmd
install-cmd: install-core install-examples

.PHONY: install-core
install-core: got.install
	install -Dm755 -- "got.install"     "$(DESTDIR)$(PREFIX)$(SBIN)/got"
	install -d     --                   "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	install  -m644 -- COPYING LICENSE   "$(DESTDIR)$(LICENSES)/$(PKGNAME)"

.PHONY: install-examples
install-examples: $(foreach EXAMPLE, $(EXAMPLES), gotrc-examples/$(EXAMPLE))
	install -d     --    "$(DESTDIR)$(SYSCONF)/gotrc.examples"
	install  -m644 -- $^ "$(DESTDIR)$(SYSCONF)/gotrc.examples"

.PHONY: install-doc
install-doc: install-info install-pdf install-ps install-dvi

.PHONY: install-info
install-info: gates-of-tartaros.info
	install -Dm644 -- "$<" "$(DESTDIR)$(DATA)/info/$(PKGNAME).info"

.PHONY: install-pdf
install-pdf: gates-of-tartaros.pdf
	install -Dm644 -- "$<" "$(DESTDIR)$(DATA)/doc/$(PKGNAME).pdf"

.PHONY: install-ps
install-ps: gates-of-tartaros.ps
	install -Dm644 -- "$<" "$(DESTDIR)$(DATA)/doc/$(PKGNAME).ps"

.PHONY: install-dvi
install-dvi: gates-of-tartaros.dvi
	install -Dm644 -- "$<" "$(DESTDIR)$(DATA)/doc/$(PKGNAME).dvi"



.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)$(SBIN)/got"
	-rm -r -- "$(DESTDIR)$(SYSCONF)/gotrc.examples"
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/LICENSE"
	-rm -d -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(DATA)/info/$(PKGNAME).info"
	-rm -- "$(DESTDIR)$(DATA)/doc/$(PKGNAME).pdf"
	-rm -- "$(DESTDIR)$(DATA)/doc/$(PKGNAME).ps"
	-rm -- "$(DESTDIR)$(DATA)/doc/$(PKGNAME).dvi"



.PHONY: clean
clean:
	-rm -fr *.install *.{info,pdf,ps,dvi} obj

