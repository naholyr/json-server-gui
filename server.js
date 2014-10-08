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


var http = require("http");
var app = require("json-server");
var path = require("path");

app.low.path = path.resolve("db.json");
app.low.db = require("./db.json");

var server = http.createServer(app);

server.listen(26080);

server.on("listening", function () {
  console.log(this.address());
});


function ping (name, req) {
  if (req.method !== "GET") {
    setTimeout(function () {
      process.emit("data-update");
    }, 100);
  }
  process.emit("request", req.method, req.url, req.body);
}
