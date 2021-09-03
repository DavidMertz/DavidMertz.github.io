(function ($) {
    "use strict";
    $('[data-toggle="tooltip"]').tooltip();
    $('.menu-switch').on('click', function (event) {
        $('.mainmenu').toggleClass('active');
        $(this).toggleClass('active');
        event.preventDefault()
    });
    new WOW().init();
    $.scrollUp({
        scrollText: '<i class="fa fa-long-arrow-up"></i>',
        easingType: 'linear',
        scrollSpeed: 900,
        animation: 'fade'
    });
    $(function () {
        $(".main-menu ul li a, .mainmenu ul li a").bind('click', function (event) {
            var $anchor = $(this);
            $('html, body').stop().animate({
                scrollTop: $($anchor.attr('href')).offset().top
            }, 1000, 'easeInOutExpo');
            event.preventDefault()
        })
    })
}(jQuery))

$(document).ready(function () {
    $('a[href*=#]').bind('click', function (e) {
        e.preventDefault(); // prevent hard jump, the default behavior

        var target = $(this).attr("href"); // Set the target as variable

        // perform animated scrolling by getting top-position of target-element and set it as scroll target
        $('html, body').stop().animate({
            scrollTop: $(target).offset().top
        }, 600, function () {
            location.hash = target; //attach the hash (#jumptarget) to the pageurl
        });

        return false;
    });
});

$(window).scroll(function () {
    var scrollDistance = $(window).scrollTop();

    // Assign active class to nav links while scolling
    $('.page-section').each(function (i) {
        if ($(this).position().top <= scrollDistance) {
            $('.navigation a.active').removeClass('active');
            $('.navigation a').eq(i).addClass('active');
        }
    });
}).scroll();
var selector = '.navigation__link';

$(selector).on('click', function () {
    $(selector).removeClass('active');
    $(this).addClass('active');
});



function bookText(section) {
    var buy = `<h3>Note on this Online Version</h3>
<p>Most, but not all of, of the published Packt title is
available at this website.  Some mentions of code setup or running
code cells will not apply to this static HTML, divided into short
sections.  There might be a few other words that are more about
the book context as well.</p>

<p>In other words, I encourage you to <b>buy the book itself!</b></p>

<img src="img/cover.png" width=50%"/>`;

    if (section != "buy") {
        var content = document.getElementById(section).innerHTML;
    } else {
        content = buy;
    }
    book_text = document.getElementById('book-text')
    book_text.innerHTML = content;
    book_text.className = "shadow";
}

function bookTitle() {
    var title = `<h2>Cleaning Data for Effective Data Science</h2>
    <h4><a href="http://kdm.training">David Mertz, Ph.D.</a>
        <a href="mailto:mertz@kdm.training">&lt;mertz@kdm.training&gt;</a>
    </h4>
    <ul class="horizontal">
        <li>Paperback: 498 pages</li>
        <li>ISBN-13: 9781801071291</li>
        <li>Date Of Publication: 30 March 2021</li>
    </ul>`;

    book_title = document.getElementById('book-title');
    book_title.innerHTML = title;
}
bookTitle();

function footer() {
    var copyright = `
    <div class="container">
    <div class="row">
        <div class="col-md-9">
            <p><b>© 2021 Packt Publishing</b></p>
            <p>Donations to the author are welcomed:<br/>
            Paypal: <a href="https://www.paypal.com/donate?hosted_button_id=WSUSCPKT5PE9L">
            Donation Link</a><br/>
            BTC: <a href="bitcoin:1GaxnVtRegebBDUknHL6ZPRLeAa8yfnFQE&label=Cleaning%20Data">
            1GaxnVtRegebBDUknHL6ZPRLeAa8yfnFQE</a><br/>
            ETH: <a href="etherium:0x300833A83e37a5374d01DfF395988ba287a6d0e1&label=Cleaning%20Data">
            0x300833A83e37a5374d01DfF395988ba287a6d0e1</a><br/>
            </p>
        </div>
    </div>
    </div>`;

    document.querySelector('footer').innerHTML = copyright;
}
footer();

function screen_size_warning() {
    var res = document.body.clientWidth * window.devicePixelRatio;
    var mobile = (/Android|webOS|iPhone|iPad|iPod|Opera Mini/i.test(navigator.userAgent));

    var screen_warning = `<h2>Device Limitation</h2><p>
Because of typographic and layout issues, navigation among the
sections of this chapter is not available on small devices or 
narrow browser windows.  Please read on a larger screen, using 
the table-of-contents available at right on those, or obtain <a href=
"https://www.amazon.com/Cleaning-Data-Effective-Science-command-line/dp/1801071292">
the printed or e-book editions</a> that escape this concern.</p>

<a href="https://www.amazon.com/Cleaning-Data-Effective-Science-command-line/dp/1801071292">
<img src="img/cover.png" width=50%"/></a>

<p><small>Debug: 
    mobile=${mobile}; 
    clientWidth=${document.body.clientWidth};
    devicePixelRatio=${window.devicePixelRatio}
</small></p>
`;

    res = document.body.clientWidth; // * window.devicePixelRatio;
    mobile = (/Android|webOS|iPhone|iPad|iPod|Opera Mini/i.test(navigator.userAgent)); 
    if ((res < 1120) || mobile) {
        book_text = document.getElementById('book-text')
        book_text.innerHTML = screen_warning;
        book_text.className = "shadow";
        main_nav = document.getElementById("mainNav");
        main_nav.outerHTML = "";
    }
}
screen_size_warning();

init_mathjax = function () {
    if (window.MathJax) {
        // MathJax loaded
        MathJax.Hub.Config({
            TeX: {
                equationNumbers: {
                    autoNumber: "AMS",
                    useLabelIds: true
                }
            },
            tex2jax: {
                inlineMath: [['$', '$'], ["\\(", "\\)"]],
                displayMath: [['$$', '$$'], ["\\[", "\\]"]],
                processEscapes: true,
                processEnvironments: true
            },
            displayAlign: 'center',
            CommonHTML: {
                linebreaks: {
                    automatic: true
                }
            },
            "HTML-CSS": {
                linebreaks: {
                    automatic: true
                }
            }
        });

        MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
    }
}
init_mathjax();

