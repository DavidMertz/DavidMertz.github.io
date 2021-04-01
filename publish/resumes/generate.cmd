/*-- Script to generate all the resume scripts in various languages --*/
call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs


/*------------- Configure the environment variables -------------*/
SAY "Configuring environment"
'@SET BEGINLIBPATH=g:\py152;g:\perl5\dll'
'@SET PATH=g:\py152;g:\perl5\bin;%path%'
'@SET PYTHONHOME=g:\py152'
'@SET PYTHONPATH=.;g:\Py152\Lib;g:\Py152\Lib\plat-win'
'@SET PERLLIB=g:/perl5/lib/site_perl;g:/perl5/lib/site_perl/os2'
'@SET PERLLIB_PREFIX=f:/perllib/lib;g:/perl5/lib'
'@SET MANPATH=g:/perl5/man;%manpath%'
'@SET PERL_SH_DIR=g:/perl5/bin'


/*---------------- Read in the plaintext version ----------------*/
src = "resume.src"
SAY "Reading plaintext resume"
txt = CHARIN(src, 1, 9999)


/*----------------- Precompute the BitXOR hash ------------------*/
SAY "Computing BitXOR hash of plaintext" src
hash=''
LINEIN(src,1,0)
DO WHILE LINES(src)=1
   hash=BITXOR(hash,LINEIN(src)); END
hash=BITXOR(LEFT(hash,40),RIGHT(hash,40))
hash=BITXOR(LEFT(hash,20),RIGHT(hash,20))
hash=BITXOR(LEFT(hash,10),RIGHT(hash,10))


/*------------ Create a Unix-style plaintext version ------------*/
SAY "Creating Unix-style plaintext (= resume.lf)"
cr = X2C('0D')
lf = X2C('0A')
lf_txt = ""
DO i=1 TO LENGTH(txt)
    ch = SUBSTR(txt,i,1)
    IF \(ch = cr)
       THEN lf_txt = lf_txt || ch
END
st = CHAROUT("resume.lf", lf_txt)


/*---------- Create JavaScript "quoted-string" version ----------*/
q_txt = ""
LINEIN(src,1,0)
DO WHILE LINES(src)=1
    q_txt = q_txt || "'" || LINEIN(src) || "\n'+" || lf
END


/*------------------- Precompute the MD5 hash -------------------*/
SAY "Computing MD5 hash of plaintext (of resume.lf)"
'@md5sum resume.lf > tmp.md5'        /* The unix output differs slightly from */
md5 = LEFT(LINEIN("tmp.md5"),33) '-' /* the OS/2 output in the second field:  */
st = STREAM("tmp.md5", 'c', 'close') /* We massage to get it like unix.       */


/*--------------- Precompute line/words/chars counts ------------*/
SAY "Computing lines/words/chars count (of resume.lf)"
'@wc resume.lf > tmp.wc'
wc = '-' LINEIN("tmp.wc")
PARSE VAR wc WITH lf_lines lf_words lf_chars fname


/*------------- Precompute the Python MD5/Base64 hash -----------*/
SAY "Computing Python MD5/Base64 hash"
rc = SysFileDelete("_.py")
st = LINEOUT("_.py", '_="""___________________________________________________________________')
st = CHAROUT("_.py", txt)
st = LINEOUT("_.py", '_____________________________________________________________________"""')
st = STREAM("_.py", 'c', 'close')
'@python -c "import md5,base64,_;print base64.encodestring(md5.new(_._).digest())">tmp.md5'
pytxt = CHARIN("_.py", 1, 9999)
pymd5 = CHARIN('tmp.md5',1,24)


/*--------------- Clean up a bit from precomputations -----------*/
SAY "...a little cleanup before we proceed"
st = STREAM("resume.lf", 'c', 'close')
rc = SysFileDelete("resume.lf")
rc = SysFileDelete("tmp.md5")
rc = SysFileDelete("tmp.wc")
st = STREAM("_.py", 'c', 'close')
st = STREAM('tmp.md5', 'c', 'close')
rc = SysFileDelete('tmp.md5')
rc = SysFileDelete("_.py")
rc = SysFileDelete("_.pyc")     /* Delete the .pyc too */
SAY "--------------------------------------------"


/*------------------- Create the BASH version -------------------*/
SAY "Creating BASH version"
out = "resume.sh"
rc = SysFileDelete(out)
st = CHAROUT(out, '#!/bin/bash'lf)
st = CHAROUT(out, 'md5sum>_<<_____________________________________________________________'lf)
st = CHAROUT(out, lf_txt)
st = CHAROUT(out, '_____________________________________________________________'lf)
st = CHAROUT(out, 'if test "$(cat _)" = "'md5'"'lf)
st = CHAROUT(out, '   then echo "This resume seems to be healthy and intact"'lf)
st = CHAROUT(out, 'else    echo "Some ne''er-do-well has altered this resume"'lf)
st = CHAROUT(out, 'fi ; rm _'lf)


/*----------------- Create the REXX/CMD version -----------------*/
SAY "Creating REXX version"
out = "resume.cmd"
rc = SysFileDelete(out)
st = LINEOUT(out, "/*-- RUN THIS RESUME TO VALIDATE IT ON SYSTEMS WITH REXX INSTALLED --*/")
st = LINEOUT(out, "DO 0")
st = CHAROUT(out, txt)
st = LINEOUT(out, "END")
st = LINEOUT(out, "i=2; hash=''; DO SOURCELINE()-10; i=i+1; hash=BITXOR(hash,SOURCELINE(i)); END")
st = LINEOUT(out, "hash=BITXOR(LEFT(hash,40),RIGHT(hash,40))")
st = LINEOUT(out, "hash=BITXOR(LEFT(hash,20),RIGHT(hash,20))")
st = LINEOUT(out, "hash=BITXOR(LEFT(hash,10),RIGHT(hash,10))")
st = LINEOUT(out, "if hash<>'"hash"' then")
st = LINEOUT(out, "     SAY 'Some ne''er-do-well has altered this resume' hash")
st = LINEOUT(out, "ELSE SAY 'This resume seems to be healthy and intact'")


/*-------------------- Create the TCL version -------------------*/
SAY "Creating TCL version"
out = "resume.tcl"
rc = SysFileDelete(out)
st = CHAROUT(out, "# ------ RUN 'tcl resume.tcl' TO CHECK RESUME AUTHENTICITY ------------"lf)
st = CHAROUT(out, "set _ {"lf)
st = CHAROUT(out, lf_txt)
st = CHAROUT(out, '}'lf)
st = CHAROUT(out, 'set c 0; foreach e [split $_] {if {$e != {}} {incr c}}'lf)
st = CHAROUT(out, 'if {"'lf_chars || lf_words'" == "[string length $_]$c"} {'lf)
st = CHAROUT(out, '         puts "This resume seems to be healthy and intact"'lf)
st = CHAROUT(out, '} else { puts "Some ne'"'"'er-do-well has altered this resume" }'lf)
st = CHAROUT(out, '# THIS RESUME DOES NOT WISH TO BE IN A PROPRIETARY FORMAT, DON'"'"'T ASK!'lf)


/*-------------------- Create the TK version -------------------*/
SAY "Creating TK version"
out = "resume.tk"
rc = SysFileDelete(out)
st = CHAROUT(out, "# ------ RUN 'wish resume.tk' TO CHECK RESUME AUTHENTICITY ------------"lf)
st = CHAROUT(out, "set _ {"lf)
st = CHAROUT(out, lf_txt)
st = CHAROUT(out, '}'lf)
st = CHAROUT(out, 'set c 0; foreach e [split $_] {if {$e != {}} {incr c}}'lf)
st = CHAROUT(out, 'button .err -command {destroy .}; pack .err'lf)
st = CHAROUT(out, 'if {"'lf_chars || lf_words'" == "[string length $_]$c"} {'lf)
st = CHAROUT(out, '         .err configure -text "This resume seems to be healthy and intact"'lf)
st = CHAROUT(out, '} else { .err configure -text "Some ne'"'"'er-do-well has altered this resume" }'lf)
st = CHAROUT(out, '# THIS RESUME DOES NOT WISH TO BE IN A PROPRIETARY FORMAT, DON'"'"'T ASK!'lf)


/*------------ Create code-detection Perl/TXT version -----------*/
SAY "Creating 'perl -x' TXT version"
out = "resume.txt"
rc = SysFileDelete(out)
st = CHAROUT(out, "-------- RUN 'perl -x resume.txt' TO CHECK RESUME AUTHENTICITY -----*--"lf)
st = CHAROUT(out, lf_txt)
st = CHAROUT(out, "--*--------------------------------------------------------------------"lf)
st = CHAROUT(out, "#!/usr/bin/perl"lf)
st = CHAROUT(out, "open(ME,$0); read ME, $_, 9999; /--\*--.*--\*--/s;"lf)
st = CHAROUT(out, "if ("lf_chars+11" != length $&)"lf)
st = CHAROUT(out, "     {print q/Some ne'er-do-well has altered this resume/,"'"\n"'" }"lf)
st = CHAROUT(out, "else {print q/This resume seems to be healthy and intact/,"'"\n"'" }"lf)
st = CHAROUT(out, "__END__"lf)
st = CHAROUT(out, "THIS RESUME DOES NOT WISH TO BE IN A PROPRIETARY FORMAT, DON'T ASK!"lf)


/*-------------- Create the simplified Perl version -------------*/
SAY "Creating simplified Perl version"
out = "resume.pl"
rc = SysFileDelete(out)
st = CHAROUT(out, "if (length <<'END'   # RUN 'perl resume.txt' TO CHECK AUTHENTICITY"lf)
st = CHAROUT(out, "------------------------------------------------------------------------"lf)
st = CHAROUT(out, lf_txt)
st = CHAROUT(out, "------------------------------------------------------------------------"lf)
st = CHAROUT(out, "END"lf)
st = CHAROUT(out, "!= "lf_chars+146") {print q/Some ne'er-do-well has altered this resume/,"'"\n"'"}"lf)
st = CHAROUT(out, "else     {print q/This resume seems to be healthy and intact/,"'"\n"'"}"lf)
st = CHAROUT(out, "__END__"lf)
st = CHAROUT(out, "THIS RESUME DOES NOT WISH TO BE IN A PROPRIETARY FORMAT, DON'T ASK!"lf)


/*------------------ Create the Python version ------------------*/
SAY "Creating Python version"
out   = "resume.py"
rc = SysFileDelete(out)
st = LINEOUT(out, "# RUN 'python resume.py' TO CHECK RESUME AUTHENTICITY")
st = CHAROUT(out, pytxt)
st = LINEOUT(out, "from md5 import *; from base64 import *")
st = LINEOUT(out, "if encodestring(new(_).digest()) <> '"pymd5"\n':")
st = LINEOUT(out, '      print "Some ne'"'"'er-do-well has altered this resume"')
st = LINEOUT(out, 'else: print "This resume seems to be healthy and intact"')
st = LINEOUT(out, "")
st = LINEOUT(out, "# THIS RESUME DOES NOT WISH TO BE IN A PROPRIETARY FORMAT, DON'T ASK!")

/*------------------- Create the HTML version -------------------*/
SAY "Creating HTML version"
out   = "resume.html"
rc = SysFileDelete(out)
st = LINEOUT(out, "<html><head><title>David Mertz Resume</title></head><body><pre>")
st = LINEOUT(out, "<noscript><h1>Resume not authenticated: JavaScript disabled</h1><hr><pre>")
st = CHAROUT(out, txt)
st = LINEOUT(out, "</pre></noscript><script><!--")
st = LINEOUT(out, 'r = new String("<pre>"+')
st = CHAROUT(out, q_txt)
st = LINEOUT(out, '"</pre>")')
st = LINEOUT(out, 'if (r.length == 'lf_chars+11') {')
st = LINEOUT(out, '   document.write("<h1>This resume seems to be healthy and intact</h1><hr>"); }')
st = LINEOUT(out, 'else {')
st = LINEOUT(out, '   document.write("<h1>Some ne'"'"'er-do-well has altered this resume</h1><hr>"); }')
st = LINEOUT(out, 'document.write(r);')
st = LINEOUT(out, '// -->')
st = LINEOUT(out, '</script></body></html>')


/*----------------------- Zip it all up -------------------------*/
st = STREAM("resume.py", 'c', 'close')
st = STREAM("resume.sh", 'c', 'close')
st = STREAM("resume.html", 'c', 'close')
st = STREAM("resume.src", 'c', 'close')
st = STREAM("resume.pl", 'c', 'close')
st = STREAM("resume.tcl", 'c', 'close')
st = STREAM("resume.tk", 'c', 'close')
st = STREAM("resume.cmd", 'c', 'close')
st = STREAM("resume.txt", 'c', 'close')

rc = SysFileDelete("resume.bak")
rc = SysFileDelete("resume.zip")
'@zip resume resume.*'
