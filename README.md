JSON Server GUI
===============

What?
-----

The `json-server` module starts a server exposing a dynamic REST API: any call to `/somethings` on your server will act like a standard REST API with no schema constraint. Checkout [the project](https://github.com/typicode/json-server) for more information.

`JSON Server GUI` just adds a GUI on top, based on `node-webkit`.

Why?
----

During JavaScript trainings you may want your trainees to work with a REST API (let's say, when you talk about Ajax :)). The best way would be to provide a single executable they can click on, and start experiments.

With this very simple GUI they can see the data in real time, and the requests they played. They have a direct feedback, without the need to tell them how to install a server, use a CLI, or even host your own server.

![Screenshot](https://raw.githubusercontent.com/naholyr/json-server-gui/master/screenshot.png)

How?
----

### Download

Pre-built binaries for latest version are available here:

* [Linux - 32 bits](https://dl.dropboxusercontent.com/u/6414656/json-server-gui/2.0.0/json-server-gui-linux32.tar.gz) (~40.3M)
* [Linux - 64 bits](https://dl.dropboxusercontent.com/u/6414656/json-server-gui/2.0.0/json-server-gui-linux64.tar.gz) (~38.6M)
* [Windows](https://dl.dropboxusercontent.com/u/6414656/json-server-gui/2.0.0/json-server-gui-win.zip) (~27.4M)
* [Mac OSX](https://dl.dropboxusercontent.com/u/6414656/json-server-gui/2.0.0/json-server-gui-osx.zip) (~32M)

### Build

Clone the repository, then run `make`. The project will build for Linux (32 & 64 bits), Windows (32 bits), and Max OSX.

It can last about a century first time as it will download all corresponding `node-webkit` distributions.

To build specific for a specific platform:

```sh
make build-linux32
make build-linux64
make build-windows
make build-osx
```

Moar!
-----

* `$APP_DIR/public` is served as document root
* `$APP_DIR/db.json` is your data file
* Some behavior can be defined from environment variables:
  * `APP_DIR` = directory where we'll search for `db.json` and `public` folder (default = app's folder)
  * `PORT` = server's port (default = 26080)

TODO
----

* Better GUI
* Persisted configuration (instead of env)

How to contribute
-----------------

* Fork & clone
* Install [node-webkit](https://github.com/rogerwang/node-webkit#downloads) for your platform (alternatively, you can run `make build-<your platform>` and grab node-webkit from `node_modules/node-webkit-builder/cache/0.10.5/<your platform>/`, saving you a duplicate download)
* Make your changes and test them by running `/path/to/nw src`
* Create a pull request
