const jsonServer = require('json-server');
const path = require('path');
const fs = require('fs');
const _ = require('lodash');
const is = require('./utils/is');
const chalk = require('chalk');
const morgan = require("morgan");
const server = jsonServer.create();
const middlewares = jsonServer.defaults();

process.chdir(path.dirname(process.execPath));

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

var configPath = path.resolve(appDir, "config/config.json");
var configFolderPath = path.resolve(appDir, "config");
if (!fs.existsSync(configPath))
{
	if (!fs.existsSync(configFolderPath))
	{
		fs.mkdirSync(configFolderPath);
	}
	fs.writeFileSync(configPath, "{}");
}
var config = JSON.parse(fs.readFileSync(configPath));
if (config.DataPath != null)
{
	var rootDir = path.resolve(config.DataPath) || process.cwd();
}
else
{
	var rootDir = process.env.APP_DIR || process.cwd();
}


console.log("Working directory:", rootDir);

var dbPath = path.resolve(rootDir, "db.json");
if (!fs.existsSync(dbPath))
{
	fs.writeFileSync(dbPath, "{}");
}

var router = jsonServer.router(dbPath);
var port = config.Port || process.env.PORT || 26080;

middlewares.push(morgan('dev', {
	skip: function(req, res) { process.emit("request", req.method, req.originalUrl, req.body); return false; }
}));

server.use(middlewares);
server.use(router);

fs.watch(rootDir, (event, file) => {
	if (file)
	{
		const watchedFile = path.resolve(rootDir, file);
		if (watchedFile == path.resolve(dbPath))
		{
			if (is.JSON(watchedFile))
			{
				let obj;
				try
				{
					obj = JSON.parse(fs.readFileSync(watchedFile));
				}
				catch (e)
				{
					console.log(chalk.red(`  Error reading ${watchedFile}`));
					console.error(e.message);
					return;
				}

				const isDatabaseDifferent = !_.isEqual(obj, router.db.getState());
				if (isDatabaseDifferent)
				{
					console.log(chalk.grey(`  ${dbPath} has changed, reloading...`));
					router.db.read();
					process.emit("data-update");
				}
			}
		}
	}
});

server.use((req, res, next) => {
	process.emit("request", req.method, req.originalUrl, req.body);
	next();
});

var serverProcess;

server.on("listening", function () {
  console.log("Server ready:", this.address());
});

function stop_server()
{
	serverProcess && serverProcess.close();
	conn("Server stopped");
}

function start_server()
{
	conn("Connecting");
	serverProcess = server.listen(port, () => {
		console.log("JSON Server is running");
		conn("Online");
	});
}