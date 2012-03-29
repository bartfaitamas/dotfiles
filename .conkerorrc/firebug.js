define_variable("firebug_url",
                "http://getfirebug.com/releases/lite/latest/firebug-lite.js#startOpened=true");
function firebug(I) {
    var doc = I.buffer.document;
    var script = doc.createElement('script');
    script.setAttribute('type', 'text/javascript');
    script.setAttribute('src', firebug_url);
    script.setAttribute('onload', 'firebug.init();');
    doc.body.appendChild(script);
}
interactive("firebug", "open firebug lite", firebug);
