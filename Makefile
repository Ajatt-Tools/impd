VERSION ?= 0.4
PROG = impd
PROG_TEMP = $(PROG).tmp

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin

all:
	@echo -e '\033[1;32mSetting version...\033[0m'
	@sed -e 's/^\(readonly version=\).*$$/\1v$(VERSION)/' $(PROG) > $(PROG_TEMP)

install:
	@echo -e '\033[1;32mInstalling the program...\033[0m'
	install -Dm755 "$(PROG_TEMP)" "$(DESTDIR)$(BINDIR)/$(PROG)"

uninstall:
	rm -- "$(DESTDIR)$(BINDIR)/$(PROG)"

clean:
	rm -f -- $(PROG_TEMP)

.PHONY: install uninstall clean
