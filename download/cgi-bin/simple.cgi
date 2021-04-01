#!/usr/bin/python
import os,sys
print "Content-Type: text/html; charset=UTF-8"
print 
print "<html><head><title>Environment test</title></head><body>"
print "<dl compact='compact'>"
for k,v in os.environ.items():
    print "<dt>",k,"</dt><dd>",v,"</dd>"
print "<dt>&lt;STDIN&gt;</dt><dd>", sys.stdin.read(), "</dd>"
print "</dl></body></html>"
