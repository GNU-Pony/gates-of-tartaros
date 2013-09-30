PREFIX =
SYSCONF = /etc
BIN = /bin
SBIN = /sbin
LICENSES = /usr/share/licenses
COMMAND = got
PKGNAME = gates-of-tartaros
SSHUSER = sshlogin

BASH_SHEBANG = /usr/bin/env bash


all: got.install got-cmd.install

got.install: got
	cp "$<" "$@"
	sed -i 's:#!/usr/bin/env bash:#!$(BASH_SHEBANG):g' "$@"
	sed -i 's:@prefix@:$(PREFIX):g' "$@"
	sed -i 's:@etc@:$(SYSCONF):g' "$@"
	sed -i 's:@command@:$(COMMAND):g' "$@"
	sed -i 's:@sshlogin@:$(SSHUSER):g' "$@"

got-cmd.install: got-cmd
	cp "$<" "$@"
	sed -i 's:#!/usr/bin/env bash:#!$(BASH_SHEBANG):g' "$@"


install: got.install got-cmd.install
	install -Dm755 -- "got.install"     "$(DESTDIR)$(PREFIX)$(SBIN)/got"
	install -Dm755 -- "got-cmd.install" "$(DESTDIR)$(PREFIX)$(BIN)/got-cmd"
	install -Dm644 -- "gotrc"           "$(DESTDIR)$(SYSCONF)/gotrc.examples/lower-left-ponysay"
	install -d     --                   "$(DESTDIR)$(LICENSES)/$(PKGNAME)"
	install  -m644 -- COPYING LICENSE   "$(DESTDIR)$(LICENSES)/$(PKGNAME)"


uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)$(SBIN)/got"
	-rm -- "$(DESTDIR)$(PREFIX)$(BIN)/got-cmd"
	-rm -- "$(DESTDIR)$(SYSCONF)/gotrc.examples/lower-left-ponysay"
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)/LICENSE"
	-rm -- "$(DESTDIR)$(LICENSES)/$(PKGNAME)"


clean:
	-rm *.install 2>/dev/null

