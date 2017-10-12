// Escape = close app
document.addEventListener("keydown", function (e) {
  if (e.keyCode == 27) {
    process.exit(0);
  }
});

// Thanks http://stackoverflow.com/questions/4810841/how-can-i-pretty-print-json-using-javascript
function syntaxHighlight(json) {
    if (typeof json === "undefined") {
        return "";
    }
    json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
        var cls = 'number';
        if (/^"/.test(match)) {
            if (/:$/.test(match)) {
                cls = 'key';
            } else {
                cls = 'string';
            }
        } else if (/true|false/.test(match)) {
            cls = 'boolean';
        } else if (/null/.test(match)) {
            cls = 'null';
        }
        return '<span class="' + cls + '">' + match + '</span>';
    });
}

var serv = true;

function clearcontent()
{
    elLogs.innerHTML = "<li>Serveur: <strong>http://localhost:" + port + "/</strong> | Status: <strong id=\"status\"></strong></li>\
        <li><a href=\"javascript:clearcontent();\">Clear logs</a> | <a href=\"javascript:btnSwitchServ()\" id=\"btnServ\">" + (serv ? "Stop server" : "Start server") + "</a></li>";
    process.emit("data-update");
    conn(null);
}

function btnSwitchServ()
{
    serv = !serv;
    document.getElementById("btnServ").innerHTML = (serv ? "Stop server" : "Start server");
    if (!serv)
    {
        stop_server();
    }
    else
    {
        start_server();
    }
}

// Refresh listing
var elData = document.getElementById("data");
console.log(server);
elData.innerHTML = syntaxHighlight(JSON.stringify(router.db.getState(), null, 2));
process.on("data-update", function () {
    elData.innerHTML = syntaxHighlight(JSON.stringify(router.db.getState(), null, 2));
});

// Logs
var elLogs = document.getElementById("logs");
process.on("request", function (method, url, body) {
    var li = '<li><strong>' + method + " " + url + '</strong>';
    if (method !== "GET" && method !== "DELETE") {
        li += '<br><code>' + JSON.stringify(body) + '</code>';
    }
    li += '</li>';
    elLogs.innerHTML += li;
    process.emit("data-update");
});