// Escape = close app
document.addEventListener("keydown", function (e) {
  if (e.keyCode == 27) {
    process.exit(0);
  }
});

// Thanks http://stackoverflow.com/questions/4810841/how-can-i-pretty-print-json-using-javascript
function syntaxHighlight(json) {
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

// Refresh listing
var elData = document.getElementById("data");
elData.innerHTML = syntaxHighlight(JSON.stringify(app.low.db, null, 2));
process.on("data-update", function () {
  elData.innerHTML = syntaxHighlight(JSON.stringify(app.low.db, null, 2));
});

// Logs
var elLogs = document.getElementById("logs");
process.on("request", function (method, url, body) {
  var li = "<li><strong>" + method + " " + url + "</strong>";
  if (method !== "GET") {
    li += "<br><code>" + JSON.stringify(body) + "</code>";
  }
  li += "</li>";
  elLogs.innerHTML += li;
});
