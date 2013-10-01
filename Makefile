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

EXAMPLES = lower-left-ponysay allow-uppercase issue-file commands no-empty-user



.PHONY: all
all: cmd doc

.PHONY: doc
doc: info

.PHONY: info
info: gates-of-tartaros.info.gz

%.info.gz: info/%.texinfo.install
	makeinfo "$<"
	gzip -9 -f "$*.info"

info/%.texinfo.install: info/%.texinfo
	cp "$<" "$@"
	sed -i 's:^@set BIN /bin:@set BIN $(PREFIX)$(BIN):g' "$@"
	sed -i 's:^@set SBIN /sbin:@set SBIN $(PREFIX)$(SBIN):g' "$@"
	sed -i 's:^@set DEV /dev:@set DEV $(DEV):g' "$@"
	sed -i 's:^@set ETC /etc:@set ETC $(SYSCONF):g' "$@"
	sed -i 's:^@set GOT got:@set GOT $(COMMAND):g' "$@"
	sed -i 's:^@set SSH ssh:@set SSH $(SSH):g' "$@"

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
install: install-cmd install-doc

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
install-doc: install-info

.PHONY: install-info
install-info: gates-of-tartaros.info.gz
	install -Dm644 -- "$<" "$(DESTDIR)$(DATA)/info/$(PKGNAME).info.gz"



.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)$(SBIN)/got"
	-rm -r -- "$(DESTDIR)$(SYSCONF)/gotrc.examples"
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/LICENSE"
	-rm -d -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(DATA)/info/$(PKGNAME).info.gz"



.PHONY: clean
clean:
	-rm *.install *.info.gz 2>/dev/null

