/*jslint esnext: true, rhine: true, es5: true */
define_variable('ril_username', 'bartfaitamas');
define_variable('ril_password', 'gather');

interactive("ril", "Read it Later",
                   function (I) {
                            let posturl = 'https://readitlaterlist.com/v2/add?username='+ril_username+'&password='+ril_password+'&apikey=0Z4A9y66d8cF2fMu42p9b46Zb8T2vqNq&url=' + I.buffer.display_uri_string + '&title=' + I.buffer.document.title;
                            yield send_http_request(load_spec({uri: posturl}));
                            I.window.minibuffer.message("Saved!");

});

define_key(default_global_keymap, "C-r", "ril");

interactive("open-ril", "Go to Read It Later website", "follow", $browser_object = "http://www.readitlaterlist.com/unread");

define_key(default_global_keymap, "C-x r", "open-ril");
