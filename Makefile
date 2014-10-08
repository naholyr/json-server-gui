SOURCES=src/node_modules $(shell find src -type f)
NWDIR=./node_modules/node-webkit-builder
NWBUILD=$(NWDIR)/bin/nwbuild.linux

.PHONY: build clean build-linux32 build-linux64 build-windows build-osx

build: build-linux32 build-linux64 build-windows build-osx

build-linux32: build/json-server-gui/linux32/json-server-gui

build-linux64: build/json-server-gui/linux64/json-server-gui

build-windows: build/json-server-gui/win/json-server-gui.exe

build-osx: build/json-server-gui/osx/json-server-gui.app

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
	mv src/db.json db.json.bak || echo "no db.json"
	$(NWBUILD) -p linux32 -o build src
	mv db.json.bak src/db.json || echo "no db.json"

build/json-server-gui/linux64/json-server-gui: $(NWBUILD) $(SOURCES)
	mv src/db.json db.json.bak || echo "no db.json"
	$(NWBUILD) -p linux64 -o build src
	mv db.json.bak src/db.json || echo "no db.json"

build/json-server-gui/win/json-server-gui.exe: $(NWBUILD) $(SOURCES)
	mv src/db.json db.json.bak || echo "no db.json"
	$(NWBUILD) -p win -o build src
	mv db.json.bak src/db.json || echo "no db.json"

build/json-server-gui/osx/json-server-gui.app: $(NWBUILD) $(SOURCES)
	mv src/db.json db.json.bak || echo "no db.json"
	$(NWBUILD) -p osx -o build src
	mv db.json.bak src/db.json || echo "no db.json"
