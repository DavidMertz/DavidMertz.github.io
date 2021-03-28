// ==UserScript==
// @name           EZ Book
// @namespace      http://gnosis.cx/
// @description    Send Facebook to side frame
// @include        http://*facebook.com/*ref=logo
// ==/UserScript==

/*
   1. Type about:config into the navigation bar and press Enter
      (ignore the warning).
   2. Type dom.disable_window_open_feature.location into the filter
      textbox. A single entry should remain.
   3. Change the value field to false.

*/
//say = alert;    // For debugging, switchable "alert()"
var say = GM_log;
var isMember = function(elem, list) { return (list.indexOf(elem)> -1) }

var ezleft = '-800';
var eztop = '0';
var ezwidth = '800';
var ezheight = '480';

//var URL='http://facebook.com/friends';
var URL='http://m.facebook.com/friends.php';    // This could be simpler

(function() {

    say("WTF?");
    var d = document;

    function ezframe(url, name) {
        var w = window.open("", name);
        w.close()
        params=
          'width='+ezwidth +
         ',height='+ezheight +
         ',left='+ezleft +
         ',top='+eztop +
         ',status=0,toolbar=0,location=0,menubar=0,directories=0,'+
         'navigation=0,resizable=0,scrollbars=0';
        w = window.open(url, name, params);
        w.focus();
        return w;
    }

    function addButton(target, func, label) {
        var button = d.createElement('button');
        var btext  = d.createTextNode(label);
        button.appendChild(btext);
        button.addEventListener('click', func, true);
        target.appendChild(button)
        return button;
    }


    function changeframe(w) {
        var hiddenNodeClasses =
          'UIStandardFrame_SidebarAds;'+
          'UIStandardFrame_FooterAds;'+
          'friend_finder;'+
          'fdh;'+
          'drag_tip;'+
          '';
        var nodeClassToRemove = hiddenNodeClasses.split(";");

        var hiddenNodeIDs =
          'channel_iframe;'+
          'sound_player_holder;'+
          'presence;'+
          'pagefooter;'+
          'js_buffer;'+
          'post_form_id;'+
          'fbnew_preview_bar;'+
          'dropmenu_container;'+
          'friends_left_cell;'+
          'friend_filters;'+
          'friends_advanced;'+
          'status_editor_friends;'+
          '';
        var nodeIdToRemove = hiddenNodeIDs.split(";");

        var newCSS=''+
        'body { } \n'+
        '.UIStandardFrame_Container { padding:0px; width:100%; } \n'+
        '.UIStandardFrame_Content { width:100%; } \n'+
        '';
        /* The addCSS function accepts two arguments:
           the document object affected, and the  CSS as a string.
           The style sheet is appended to the DOM tree.
        */
        function addCSS(doc, innerCSS){
            var h=doc.getElementsByTagName("head");
            if(!h.length) return;
            var newStyleSheet=doc.createElement("style");
            newStyleSheet.type="text/css";
            h[0].appendChild(newStyleSheet);
            try {
                newStyleSheet.styleSheet.cssText=innerCSS;
            }
            catch(e) {
                try {
                    newStyleSheet.appendChild(doc.createTextNode(innerCSS));
                    newStyleSheet.innerHTML=innerCSS;
                }
                catch(e) {}
            }
        }
        body = w.document.getElementsByTagName("body")[0];
        //body.innerHTML = "Hello world";
        var doc = w.document;

        // First take out unpleasant div ids
        for (var i=0; i<nodeIdToRemove.length; i++) {
            var id = nodeIdToRemove[i];
            var div = doc.getElementById(id);
            if (div != null) {
                removed += id+"\n";
                div.parentNode.removeChild(div);
            }
        }
        // Then also remove unwanted div classes
        var divs = body.getElementsByTagName('div');
        for (var i=0; i<divs.length; i++) {
            var div = divs[i];
            if (div.hasAttribute('class')) {
                var klass = div.getAttribute('class');

                if (isMember(klass, nodeClassToRemove)) {
                    removed += klass+"\n";
                    div.parentNode.removeChild(div);
                }
            }
        }
        say('Removed:\n'+removed);

        // CSS touchups to reformat content
        addCSS(w.document, newCSS);
        say("Changed CSS");

        // Poke into content itself to customize
        var divs = body.getElementsByTagName('div');
        for (var i=0; i<divs.length; i++) {
            div = divs[i];
            if (div.hasAttribute('class') &
                div.getAttribute('class') == 'fsummary') {
                div.innerHTML =
                  "<table width='100%' border='0' bgcolor='lightgreen'><tr>"+
                    "<td width='50%'><font size='+2'><b>EZFrame</b></font></td>"+
                    "<td><font size='+1'>Recent Status Updates of Facebook Friends</font><font></td>"+
                  "</tr></table>";
                say("Updated/customized content");
            }
        }
    }

    //------------------------------------------------------------------
    // The main() function
    //------------------------------------------------------------------

    if(location.href.match(/http:\/\/www\.facebook\.com/)) {

        //-- Add the menu option as well
        if (!GM_registerMenuCommand) {
            GM_log('Please upgrade to the latest version of Greasemonkey.');
            return;
        } else {
            GM_registerMenuCommand("EZFrame",
                function() { ezframe(URL,'ezwindow'); } );
        }

        // For the moment, just use mobile version w/o reformat
        ezframe(URL,'ezwindow');
        //changeframe(w);
    }

})();