SCRIPTS := $(wildcard ./*.bash)

install: $(SCRIPTS)
	mkdir -p ~/bin
	cp $(SCRIPTS) ~/bin
	cp .bash_aliases ~
