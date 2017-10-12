VERSION	=	$(shell cat src/package.json | grep -F version | grep -o "[0-9]\+.[0-9]\+.[0.9]\+")

ifndef NPM

NPM	=	npm

endif

build: build-linux32 build-linux64 build-windows32 build-windows64

build-linux32: build/linux32

build-linux64: build/linux64

build-windows32: build/win32

build-windows64: build/win64

build-osx: build/osx

dist: clean build
	@rm -rf dist/$(VERSION)
	cd build/json-server-gui && mv linux32 json-server-gui-linux32 && tar zcvf json-server-gui-linux32.tar.gz json-server-gui-linux32 && rm -rf json-server-gui-linux32
	cd build/json-server-gui && mv linux64 json-server-gui-linux64 && tar zcvf json-server-gui-linux64.tar.gz json-server-gui-linux64 && rm -rf json-server-gui-linux64
	cd build/json-server-gui && mv osx     json-server-gui-osx     && zip -r   json-server-gui-osx.zip        json-server-gui-osx     && rm -rf json-server-gui-osx
	cd build/json-server-gui && mv win32   json-server-gui-win32   && zip -r   json-server-gui-win32.zip      json-server-gui-win32   && rm -rf json-server-gui-win32
	cd build/json-server-gui && mv win64   json-server-gui-win64   && zip -r   json-server-gui-win64.zip      json-server-gui-win64   && rm -rf json-server-gui-win64
	mkdir -p dist/$(VERSION)
	mv build/json-server-gui/json-server-gui-linux32.tar.gz dist/$(VERSION)/
	mv build/json-server-gui/json-server-gui-linux64.tar.gz dist/$(VERSION)/
	mv build/json-server-gui/json-server-gui-osx.zip        dist/$(VERSION)/
	mv build/json-server-gui/json-server-gui-win32.zip      dist/$(VERSION)/
	mv build/json-server-gui/json-server-gui-win64.zip      dist/$(VERSION)/

release: dist
	mv dist/$(VERSION) ~/Dropbox/Public/json-server-gui/
	sed -i "s/json-server-gui\/[0-9]\+.[0-9]\+.[0-9]\+\/json-server-gui-/json-server-gui\/$(VERSION)\/json-server-gui-/g" README.md

clean:
	rm -rf build

src/node_modules:
	cd src/ && npm install

node_modules: src/node_modules
	npm install

update:
	cd src/ && npm update
	npm update

build/linux32: node_modules
	@mv src/db.json db.json.bak 2> /dev/null || echo no db.json
	$(NPM) run build-linux32
	@mv db.json.bak src/db.json 2> /dev/null || echo 
	@touch build/linux32

build/linux64: node_modules
	@mv src/db.json db.json.bak 2> /dev/null || echo no db.json
	$(NPM) run build-linux64
	@mv db.json.bak src/db.json 2> /dev/null || echo 
	@touch build/linux64

build/win32: node_modules
	@mv src/db.json db.json.bak 2> /dev/null || echo no db.json
	$(NPM) run build-win32
	@mv db.json.bak src/db.json 2> /dev/null || echo 
	@touch build/win32

build/win64: node_modules
	@mv src/db.json db.json.bak 2> /dev/null || echo no db.json
	$(NPM) run build-win64
	@mv db.json.bak src/db.json 2> /dev/null || echo 
	@touch build/win64

build/osx: node_modules
	@mv src/db.json db.json.bak 2> /dev/null || echo no db.json
	$(NPM) run build-osx
	@mv db.json.bak src/db.json 2> /dev/null || echo 
	@touch build/osx

.PHONY: build clean build-linux32 build-linux64 build-windows build-osx dist release
