SOURCES=src/node_modules $(shell find src -type f)
NWDIR=./node_modules/node-webkit-builder
NWBUILD=$(NWDIR)/bin/nwbuild.linux
VERSION=$(shell cat src/package.json | grep -F '"version":' | grep -o "[0-9]\+.[0-9]\+.[0.9]\+")

.PHONY: build clean build-linux32 build-linux64 build-windows build-osx dist release

build: build-linux32 build-linux64 build-windows build-osx

build-linux32: build/json-server-gui/linux32/json-server-gui

build-linux64: build/json-server-gui/linux64/json-server-gui

build-windows: build/json-server-gui/win/json-server-gui.exe

build-osx: build/json-server-gui/osx/json-server-gui.app

dist: clean build
	@rm -rf dist/$(VERSION)
	cd build/json-server-gui && mv linux32 json-server-gui-linux32 && tar zcvf json-server-gui-linux32.tar.gz json-server-gui-linux32 && rm -rf json-server-gui-linux32
	cd build/json-server-gui && mv linux64 json-server-gui-linux64 && tar zcvf json-server-gui-linux64.tar.gz json-server-gui-linux64 && rm -rf json-server-gui-linux64
	cd build/json-server-gui && mv osx     json-server-gui-osx     && zip -r   json-server-gui-osx.zip        json-server-gui-osx     && rm -rf json-server-gui-osx
	cd build/json-server-gui && mv win     json-server-gui-win     && zip -r   json-server-gui-win.zip        json-server-gui-win     && rm -rf json-server-gui-win
	mkdir -p dist/$(VERSION)
	mv build/json-server-gui/json-server-gui-linux32.tar.gz dist/$(VERSION)/
	mv build/json-server-gui/json-server-gui-linux64.tar.gz dist/$(VERSION)/
	mv build/json-server-gui/json-server-gui-osx.zip        dist/$(VERSION)/
	mv build/json-server-gui/json-server-gui-win.zip        dist/$(VERSION)/

release: dist
	mv dist/$(VERSION) ~/Dropbox/Public/json-server-gui/
	sed -i "s/json-server-gui\/[0-9]\+.[0-9]\+.[0-9]\+\/json-server-gui-/json-server-gui\/$(VERSION)\/json-server-gui-/g" README.md

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
	@mv src/db.json db.json.bak 2> /dev/null || echo "no db.json"
	$(NWBUILD) -p linux32 -o build src
	@mv db.json.bak src/db.json 2> /dev/null || echo "no db.json"

build/json-server-gui/linux64/json-server-gui: $(NWBUILD) $(SOURCES)
	@mv src/db.json db.json.bak 2> /dev/null || echo "no db.json"
	$(NWBUILD) -p linux64 -o build src
	@mv db.json.bak src/db.json 2> /dev/null || echo "no db.json"

build/json-server-gui/win/json-server-gui.exe: $(NWBUILD) $(SOURCES)
	@mv src/db.json db.json.bak 2> /dev/null || echo "no db.json"
	$(NWBUILD) -p win -o build src
	@mv db.json.bak src/db.json 2> /dev/null || echo "no db.json"

build/json-server-gui/osx/json-server-gui.app: $(NWBUILD) $(SOURCES)
	@mv src/db.json db.json.bak 2> /dev/null || echo "no db.json"
	$(NWBUILD) -p osx -o build src
	@mv db.json.bak src/db.json 2> /dev/null || echo "no db.json"
