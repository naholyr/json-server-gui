SOURCES=src/node_modules $(shell find src -type f)
NWDIR=./node_modules/node-webkit-builder
NWBUILD=$(NWDIR)/bin/nwbuild.linux

.PHONY: build clean

build: build/json-server-gui/linux32/json-server-gui build/json-server-gui/linux64/json-server-gui build/json-server-gui/win/json-server-gui.exe build/json-server-gui/osx/json-server-gui.app

clean:
	rm -rf build

$(NWBUILD): node_modules
	cp $(NWDIR)/bin/nwbuild $(NWDIR)/bin/nwbuild.win
	tr -d '\015' < $(NWDIR)/bin/nwbuild.win > $@
	chmod +x $@

src/node_modules:
	cd src && npm install

node_modules:
	npm install

build/json-server-gui/linux32/json-server-gui: $(NWBUILD) $(SOURCES)
	$(NWBUILD) -p linux32 -o build src

build/json-server-gui/linux64/json-server-gui: $(NWBUILD) $(SOURCES)
	$(NWBUILD) -p linux64 -o build src

build/json-server-gui/win/json-server-gui.exe: $(NWBUILD) $(SOURCES)
	$(NWBUILD) -p win -o build src

build/json-server-gui/osx/json-server-gui.app: $(NWBUILD) $(SOURCES)
	$(NWBUILD) -p osx -o build src
