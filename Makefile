PROG = impd

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin

PROG_PATH=$(DESTDIR)/$(BINDIR)/$(PROG)

all:
	@echo -e "\033[1;32mThis program doesn't need to be built. Run \"make install\".\033[0m"

install:
	@echo -e '\033[1;32mInstalling the program...\033[0m'
	install -Dm755 "$(PROG)" "$(PROG_PATH)"

uninstall:
	@echo -e '\033[1;32mUninstalling the program...\033[0m'
	rm -- "$(PROG_PATH)"

.PHONY: install uninstall
