PROG = impd
PROG_TEMP = $(PROG).tmp

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin

all:
	@echo -e "\033[1;32mThis program doesn't need to be built. Run \"make install\".\033[0m"

install:
	@echo -e '\033[1;32mInstalling the program...\033[0m'
	install -Dm755 "$(PROG)" "$(DESTDIR)$(BINDIR)/$(PROG)"

uninstall:
	@echo -e '\033[1;32mUninstalling the program...\033[0m'
	rm -- "$(DESTDIR)$(BINDIR)/$(PROG)"

.PHONY: install uninstall
