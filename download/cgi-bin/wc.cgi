#!/usr/bin/python

import cgi, sys
from urllib import urlopen
from string import split, join

def wc(s):
    return len(split(s,'\n')), len(split(s)), len(s)

sys.stderr = sys.stdout
print "Content-type: text/html\n"
form = cgi.FieldStorage()

if form.has_key('source'):
    src = form['source'].value
    s = urlopen(src).read()
    print '<html><head><title>Word count for: %s</title></head>' % src
    print '<body><pre>'
    print '%8i%8i%8i %s' % (wc(s)+(src,))
    print '</pre></body></html>'
else:
    print '<html><head><title>No specified document source</title></head>'
    print '<body>No specified document source</body></html>'
