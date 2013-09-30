PREFIX =
SYSCONF = /etc
DEV = /dev
BIN = /bin
SBIN = /sbin
DATA = /usr/share
LICENSES = $(DATA)/licenses
COMMAND = got
PKGNAME = gates-of-tartaros
SSHUSER = sshlogin
SSH = ssh

BASH_SHEBANG = /usr/bin/env bash



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

.PHONY: cmd
cmd: got.install got-cmd.install

got.install: got
	cp "$<" "$@"
	sed -i 's:#!/usr/bin/env bash:#!$(BASH_SHEBANG):g' "$@"
	sed -i 's:@prefix@:$(PREFIX):g' "$@"
	sed -i 's:@dev@:$(DEV):g' "$@"
	sed -i 's:@etc@:$(SYSCONF):g' "$@"
	sed -i 's:@command@:$(COMMAND):g' "$@"
	sed -i 's:@sshlogin@:$(SSHUSER):g' "$@"
	sed -i 's:@ssh@:$(SSH):g' "$@"

got-cmd.install: got-cmd
	cp "$<" "$@"
	sed -i 's:#!/usr/bin/env bash:#!$(BASH_SHEBANG):g' "$@"



.PHONY: install
install: install-cmd install-doc

.PHONY: install-cmd
install-cmd: got.install got-cmd.install
	install -Dm755 -- "got.install"     "$(DESTDIR)$(PREFIX)$(SBIN)/got"
	install -Dm755 -- "got-cmd.install" "$(DESTDIR)$(PREFIX)$(BIN)/got-cmd"
	install -Dm644 -- "gotrc"           "$(DESTDIR)$(SYSCONF)/gotrc.examples/lower-left-ponysay"
	install -d     --                   "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	install  -m644 -- COPYING LICENSE   "$(DESTDIR)$(LICENSES)/$(PKGNAME)"

.PHONY: install-doc
install-doc: install-info

.PHONY: install-info
install-info: gates-of-tartaros.info.gz
	install -Dm644 -- "$<" "$(DESTDIR)$(DATA)/info/$(PKGNAME).info.gz"



.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)$(SBIN)/got"
	-rm -- "$(DESTDIR)$(PREFIX)$(BIN)/got-cmd"
	-rm -- "$(DESTDIR)$(SYSCONF)/gotrc.examples/lower-left-ponysay"
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/LICENSE"
	-rm -d -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(DATA)/info/$(PKGNAME).info.gz"



.PHONY: clean
clean:
	-rm *.install *.info.gz 2>/dev/null

