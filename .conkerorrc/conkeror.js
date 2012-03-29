// -*- js3 -*-

//allow for 'contrib' stuff
load_paths.unshift("chrome://conkeror-contrib/content/");

// teach me something whenever I start my browser
homepage = "http://en.wikipedia.org/wiki/Special:Random";

// give me new tabs; open buffers (tabs) in the background
require("new-tabs.js");
require("clicks-in-new-buffer.js");
clicks_in_new_buffer_target = OPEN_NEW_BUFFER_BACKGROUND;
clicks_in_new_buffer_button = 1; //  midclick links in new buffers with

// auto completion in the minibuffer
minibuffer_auto_complete_default = true;
url_completion_use_history = true; // should work since bf05c87405
url_completion_use_bookmarks = true;

// funky icons in the modeline
require("mode-line.js");
require("mode-line-buttons.js");
mode_line_add_buttons(standard_mode_line_buttons, true);
add_hook("mode_line_hook", mode_line_adder(loading_count_widget), true); // we'd like to see the # of buffers being loaded
remove_hook("mode_line_hook", mode_line_adder(clock_widget)); // we don't need a clock

// webjumps
define_delicious_webjumps ("bartfaitamas");
define_lastfm_webjumps ("bartfaitamas");

// Keys
//define_key(content_buffer_normal_keymap, "F", "follow-new-buffer");

// Session
require("session.js");
session_auto_save_auto_load = true;

// adblock plus
require('adblockplus');
