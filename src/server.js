var http = require("http");
var path = require("path");
var fs = require("fs");


// Monkey-patch json-server routes to trigger event
var routes = require("json-server/src/routes");
for (var route in routes) {
  routes[route] = wrapRoute(route, routes[route]);
}
function wrapRoute (name, route) {
  return function (req, res, next) {
    ping(name, req);
    route(req, res, next);
  }
}


// Get current directory
var appDir = process.env.APP_DIR || process.cwd();
// Get execPath
// /path/to/nw if run as "nw project.nw"
// /tmp/.org.chromium.Chromium.RQPJgQ if run as packaged executable
var execName = path.basename(process.execPath);
// TODO Mac OS binary name?
if (execName !== "nw" && execName !== "nw.exe") {
  // Run as direct executable
  appDir = path.dirname(process.execPath);
}

console.log("Working directory:", appDir);


var app = require("json-server");

app.low.path = path.resolve(appDir, "db.json");
if (!fs.existsSync(app.low.path)) {
  fs.writeFileSync(app.low.path, "{}");
}

app.low.db = require(app.low.path);

var server = http.createServer(app);
app.port = process.env.PORT || 26080;

server.listen(app.port);

server.on("listening", function () {
  console.log("Server ready:", this.address());
});


function ping (name, req) {
  if (req.method !== "GET") {
    setTimeout(function () {
      process.emit("data-update");
    }, 100);
  }
  process.emit("request", req.method, req.url, req.body);
}
