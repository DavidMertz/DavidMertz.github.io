#!/home/98/46/2924698/bin/python2.3
import os, cgi, cgitb
cgitb.enable()
print "Content-Type: text/html"
print 

form = cgi.FieldStorage()
os.chdir('./pywikipedia')
cmd = '/home/98/46/2924698/bin/python2.3 citation_tool.py --output=html '
opts = ''
for key in form.keys():
    opts += "--%s='%s' "  % (key, form[key].value)
output = os.popen(cmd+opts).read()
print output
#open('citation.log','a').write(opts+'\n')

