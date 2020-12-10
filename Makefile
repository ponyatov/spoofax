# \ <section:var>
MODULE     = $(notdir $(CURDIR))
OS         = $(shell uname -s)
MACHINE    = $(shell uname -m)
NOW        = $(shell date +%d%m%y)
REL        = $(shell git rev-parse --short=4 HEAD)
# / <section:var>
# \ <section:dir>
CWD        = $(CURDIR)
DOC        = $(CWD)/doc
BIN        = $(CWD)/bin
SRC        = $(CWD)/src
TMP        = $(CWD)/tmp
# / <section:dir>
# \ <section:tool>
WGET       = wget -c
# / <section:tool>
# \ <section:obj>
# / <section:obj>
# \ <section:all>
.PHONY: all
all: 	
# / <section:all>
# \ <section:doc>
.PHONY: doc
doc:  

# / <section:doc>
# \ <section:install>
.PHONY: install
install: $(OS)_install
	$(MAKE)   doc
.PHONY: update
update: $(OS)_update
.PHONY: $(OS)_install $(OS)_update
$(OS)_install $(OS)_update:
	sudo apt update
	sudo apt install -u `cat apt.txt`
# / <section:install>
# \ <section:merge>
MERGE  = Makefile README.md apt.txt .gitignore .vscode $(S)
.PHONY: main
main:
	git push -v
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)
.PHONY: shadow
shadow:
	git pull -v
	git checkout $@
	git pull -v
.PHONY: release
release:
	git tag $(NOW)-$(REL)
	git push -v && git push -v --tags
	$(MAKE) shadow
.PHONY: zip
zip:
	git archive \
		--format zip \
		--output $(TMP)/$(MODULE)_$(NOW)_$(REL).src.zip \
	HEAD
# / <section:merge>
