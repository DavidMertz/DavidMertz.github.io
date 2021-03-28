// ==UserScript==
// @name           EZ Tube
// @namespace      http://gnosis.cx/
// @description    Play Youtube videos in side frame
// @include        http://*youtube.com/watch*
// ==/UserScript==

/*
   1. Type about:config into the navigation bar and press Enter
      (ignore the warning).
   2. Type dom.disable_window_open_feature.location into the filter
      textbox. A single entry should remain.
   3. Change the value field to false.

*/

var ezleft = '-800';
var eztop = '0';
var ezwidth = '800';
var ezheight = '480';

(function() {

    var d = document;

    function ezframe(x, name, title, type) {
        var w = window.open("", name);
        w.close()

        params=
          'width='+ezwidth +
         ',height='+ezheight +
         ',left='+ezleft +
         ',top='+eztop +
         ',status=0,toolbar=0,location=0,menubar=0,directories=0,'+
         'navigation=0,resizable=0,scrollbars=0';

        w = window.open("", name, params);
        w.focus();

        // Frame it in HTML if it is SWF
        if (type=='SWF') {
            w.document.write(
                "<html><head><title>" +
                title + "</title></head><body>" +
                "<iframe width='100%' height='100%' " +
                "frameborder='0' src='"+ x +
                "'></iframe></body></html>");
        } else if (type='VID') {
            // We need to utilize SWFObject to do this (later: XXX)
            var body = w.document.getElementsByTagName('body')[0];
            body.appendChild(x);
            var player = w.document.getElementById('movie_player');
            alert(player);
            player.setSize(ezwidth, ezheight);
        }

        //player.playVideo();

        return w;
    }

    function show_here(container, elem, remove) {
        for (var i=0; i<remove.length; i++) {
            container.removeChild(remove[i]);
        }
        container.appendChild(elem);
    }

    function addButton(target, func, label) {
        var button = d.createElement('button');
        var btext  = d.createTextNode(label);
        button.appendChild(btext);
        button.addEventListener('click', func, true);
        target.appendChild(button)
        return button;
    }


    //------------------------------------------------------------------
    // The main() function
    //------------------------------------------------------------------

    if(location.href.match(/http:\/\/[a-zA-Z\.]*youtube\.com\/watch/)) {
        //-- Need that video window launched by button
        var vid = d.getElementById('embed_code');
        var obj = d.createElement('div');
        obj.innerHTML = vid.value;
        var e = obj.getElementsByTagName('embed')[0];
        var url = e.getAttribute('src');
        var watch = d.getElementById('watch-this-vid');
        var vid = d.getElementById('watch-player-div');
        var ez_button = addButton(
            watch,
            function () { ezframe(url,'ezwindow',d.title,'SWF'); },
            'Show in EZFrame');
        var here_button = addButton(
            watch,
            function () { show_here(watch,vid,[ez_button,here_button]);
                          var w = window.open("", 'ezwindow');
                          w.close(); },
            'Show Video Here');
        watch.removeChild(vid);
        ezframe(url,'ezwindow',d.title,'SWF');

        //-- Add the menu option as well
        if (!GM_registerMenuCommand) {
            GM_log('Please upgrade to the latest version of Greasemonkey.');
            return;
        } else {
            GM_registerMenuCommand("EZFrame",
                function() { ezframe(url,'ezwindow',d.title,'SWF'); });
        }
    }

})();