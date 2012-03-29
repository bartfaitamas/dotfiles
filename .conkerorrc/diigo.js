/* -*- js3 -*- */
define_variable('diigo_script_url',
               "http://www.diigo.com/javascripts/webtoolbar/diigolet_b_h_b.js");
function diigo(I) {
    var d = I.buffer.document;
    if (!d.body) {
        throw('Please wait until the page has loaded');
    }

    var script = d.createElement('script');
    script.setAttribute('src', diigo_script_url);
    d.body.appendChild(script);
}
interactive("diigo", "Show diigo toolbar", diigo);
