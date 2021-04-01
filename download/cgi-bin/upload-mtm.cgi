#!/usr/bin/python

# Simple multi-file uploader.... (change some settings below)
# (Didn't really plan to release this, but what the heck...)
# version 1.0 (Script by Tim Middleton)

# ----------------------------some constant settings----------------------------------
dirUpload = "mtm"               # directory for upload; will be created if doesn't exist
maxkb = 25000                   # maximum kilobytes to store before no more files accepted
link = "feedback.py"            # a page/url to link at the bottom of page after upload 
email = "maven@gnosis.cx"       # where to email upload reports;
sendmail = "/usr/sbin/sendmail" # sendmail will email notification of uploads

# ====================================================================================
# that's all the general settings... now for the code....
# ====================================================================================
import sys,os,cgi,glob,string

sys.stderr = sys.stdout
print "content-type: text/html\n"

def plural(s,num):
    "Make plural words nicely as possible."
    if num<>1:
        if s[-1] == "s" or s[-1] == "x":
            s = s + "e"
        s = s + "s"
    return s
    
def mailme(msg=""):
    "Quick and dirty, pipe a message to sendmail, appending various environmental variables to the message."
    if email:
        try:
            o = os.popen("%s -t" % sendmail,"w")
            o.write("To: %s\n" % email)
            o.write("From: %s\n" % email)
            o.write("Subject: %s\n" % "Upload to ~/upload/")
            o.write('X-Happy: g2G g33 g3B g3C g3M g42 g43 g46 g4C g4E\n')
            o.write("\n")
            o.write("%s\n" % msg)
            o.write("---------------------------------------\n")
            for x in [ 'REQUEST_URI','HTTP_USER_AGENT','REMOTE_ADDR','HTTP_FROM','REMOTE_HOST','REMOTE_PORT','SERVER_SOFTWARE','HTTP_REFERER','REMOTE_IDENT','REMOTE_USER','QUERY_STRING','DATE_LOCAL','HTTP_COOKIE' ]:
                if os.environ.has_key(x):
                    o.write("%s: %s\n" % (x, os.environ[x]))
            o.write("---------------------------------------\n")
            o.close()                                        
        except IOError:
            pass                                        
            

########################################################################################
def form(posturl,files,kb,maxkb,button):
    "Print the main form."
    print """<html>
<head>
<title>Meagan Thompson-Mann Gnosis File Upload</title>
<body>

<h2>UPLOAD FILES:</h2>

<P>
There's currently %s %s equaling %.2f kb (of a maximum of %s kb allowed) in the upload area.

<form action="%s" method="POST" enctype="multipart/form-data">
Name of File 1: <input name="file.1" type="file" size="50">
<BR>
Name of File 2: <input name="file.2" type="file" size="50">
<BR>
Name of File 3: <input name="file.3" type="file" size="50">
<BR>
Name of File 4: <input name="file.4" type="file" size="50">
<BR>
Name of File 5: <input name="file.5" type="file" size="50">
<BR>
Name of File 6: <input name="file.6" type="file" size="50">
<P>
<input name="submit" %s>
</form>
</body>
</html>
""" % (files,plural("file",files),kb/1024.0,maxkb,posturl,button)
########################################################################################

if os.environ.has_key("HTTP_USER_AGENT"):
    browser = os.environ["HTTP_USER_AGENT"]
else:
    browser = "No Known Browser"

if os.environ.has_key("SCRIPT_NAME"):
    posturl = os.environ["SCRIPT_NAME"]
else:
    posturl = ""

#posturl = "test.py"

kb = 0

fns = glob.glob(dirUpload+os.sep+"*")
for x in fns:
    kb = kb + os.stat(x)[6]

if kb/1024<maxkb:
    button = 'type="submit" value="Upload File(s)"'
else:
    button = 'type="button" value="Upload Disabled (maximum KB reached)"'

data = cgi.FieldStorage()


if data.has_key("file.1"):  # we have uploads.

    if kb/1024>maxkb:
        print "<HTML><HEAD><TITLE>Upload Aborted</TITLE></HEAD><BODY>"
        msg = "There are already %.2f kb files in the upload area, which is more than the %s kb maximum. Therefore your files have not been accepted, sorry." % (kb / 1024.0, maxkb)
        print msg
        print "</BODY></HTML>"
        mailme(msg)
        sys.exit()

    if not os.path.exists(dirUpload):
        os.mkdir(dirUpload,0777)

    fnList = []
    kbList = []
    kbCount = 0
    f = 1
    while f:
        key = "file.%s" % f
        if data.has_key(key):
            fn = data[key].filename
            if not fn:
                f = f + 1
                continue
            if string.rfind(data[key].filename,"\\") >= 0:
                fn = fn[string.rfind(data[key].filename,"\\"):]
            if string.rfind(data[key].filename,"/") >= 0:
                fn = fn[string.rfind(data[key].filename,"/"):]
            if string.rfind(data[key].filename,":") >= 0:
                fn = fn[string.rfind(data[key].filename,":"):]

            o = open(dirUpload+os.sep+fn,"wb")
            o.write(data[key].value)
            o.close()

            fnList.append(fn)
            kbList.append(len(data[key].value))
            kbCount = kbCount + len(data[key].value)
            f = f + 1
        else:
            f = 0


    print "<HTML><HEAD><TITLE>Upload Results</TITLE></HEAD><BODY>"
    if len(fnList):
        msg = "<H2>%s %s totalling %.2f kb uploaded successfully:</H2>\n\n" % (len(fnList),plural("file",len(fnList)),kbCount / 1024.0)        
        print msg
        print "<HR><P><UL>"
        for x in range(0,len(fnList)):
            msg = msg + "  * %s (%.2f kb)\n" % (fnList[x],kbList[x] / 1024.0)
            print "<LI>%s (%.2f kb)" % (fnList[x],kbList[x] / 1024.0)
        print "</UL>"
        print "<P><HR>"
            
        print "Now a total of %.2f kb in %s %s in the upload area.<BR>" % ((kb + kbCount) / 1024.0,len(fnList)+len(fns),plural("file",len(fnList)+len(fns)))
        print 'Your browser I.D. is <B>%s</B>.' % browser
        #if string.find(browser,"Opera"
        
        print '<HR><CENTER><FONT SIZE="-1"><A HREF="%s">Thanks</A></FONT></CENTER>' % link
        mailme(msg[4:]+"\n\n")
    else:
        print "No files were recieved."

    print "</BODY></HTML>"

else:
    form(posturl,len(fns),kb,maxkb,button)

# the end


