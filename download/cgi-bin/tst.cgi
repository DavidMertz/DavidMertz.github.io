#!/usr/bin/python

"""Check txt2html.txt for prepared documentation
   Docs may be updated with 'txt2html.cgi -rebuild_docs'
"""

from dmTxt2Html import *

# Set options based on runmode (shell vs. CGI)
if len(sys.argv) >= 2:
    cfg_dict = ParseArgs(sys.argv[1:])
else:
    cfg_dict = ParseCGI()


print "content-type: text/html\n\n"
print "got message 3"

if cfg_dict: main(cfg_dict)

