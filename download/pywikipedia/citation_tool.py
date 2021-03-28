#!/usr/bin/env python
import sys, re, os
import wikipedia, login
from urllib import quote, quote_plus, urlopen
from cgi import escape

MULTI = 'Multiple contents for same named reference'
NON1ST = 'Contents not in first named reference'
baseurl = 'http://gnosis.cx/cgi-bin/check_refs.py'
wikiurl = 'http://en.wikipedia.org/wiki/'
modurl = 'http://en.wikipedia.org/w/index.php?'
pageName = ''
summary = 'Semi-bot assisted fixes to m:Cite.php errors (see [[User:CitationTool]])'
random_article = 'http://en.wikipedia.org/wiki/Special:Random'  

def randomPage():
    pageName = None
    while not pageName:
        cmd = 'lynx -dump %s | grep  ^[A-Z] | head -1' % random_article
        pageName = os.popen(cmd).read().strip()
    return pageName

class Ref(object):
    __slots__ = 'sre name content start end'.split()
    def __init__(self, sre, offset, txt):
        self.sre = sre
        self.start = sre.start()+offset
        self.end = sre.end()+offset
        ref_txt = txt[self.start:self.end]
        self.add_name(ref_txt)
        self.add_content(ref_txt)

    def __str__(self):
        if not self.name:
            type = 'Unnamed'
            content = self.content.encode('ascii','xmlcharrefreplace')
            if len(content) > 71:
                content = content[:68]+"..."
            return "(%s) %s" % (type, content)

        elif self.content:
            type = 'Named/Content' 
            content = self.content.encode('ascii','xmlcharrefreplace')
            name = self.name.encode('utf-8')
            if len(content) > 69-len(name):
                content = content[:(66-len(name))]+"..."
            return "(%s) %s -> %s" % (type, name, content)
        else:
            type = 'Named/Empty'
            return "(%s) %s" % (type, self.name.encode('ascii','xmlcharrefreplace'))
    __repr__ = __str__
        
    def add_name(self, txt):
        txt = txt.replace('"','').replace("'","")
        name = re.search(r'(?s)(?<=name=)[\s\w].*?(?=[/>])', txt)
        if name is not None:
            name = name.group().strip()
        self.name = name
        
    def add_content(self, txt):
        content = re.search(r'(?s)(?<=>).*(?=<)', txt)
        if content is not None:
            content = content.group().strip()
        self.content = content

def get_raw(opts):
    opts.munged_name = opts.pageName.replace('/',':')
    if (opts.action.lower() == 'fix' 
            and os.path.exists('./cache/'+opts.munged_name)):
        txt = open('./cache/'+opts.munged_name).read()
        return unicode(txt,'utf-8','xmlcharrefreplace')
    site = wikipedia.getSite()
    page = wikipedia.Page(site, opts.pageName)
    txt = page.get()
    wikipedia.stopme()
    open('./cache/'+opts.munged_name,'w').write(txt.encode('utf-8'))
    return txt
    
def write_page(txt, pageName):
    site = wikipedia.getSite()
    login.LoginManager('CitationTool', False, site)
    wikipedia.setAction('Semi-bot fixes to m:Cite.php errors by [[User:CitationTool]]')
    page = wikipedia.Page(site, pageName)
    page.put(txt)
    wikipedia.stopme()

def get_refs(txt):
    all_txt = txt
    match = True
    refs = []
    while match:
        if not refs: 
            offset = 0
        else:
            offset = refs[-1].end

        pat  = r'(?s)(<ref\s+name=[^<]*?/>)'
        pat += r'|(<ref\s+name=[^<]*?>.*?</ref\s*>)'
        pat += r'|(<ref\s*>.*?</ref\s*>)'
        match = re.search(pat, txt)
        
        if match is not None:
            refs.append(Ref(match, offset, all_txt))
            txt = txt[match.end():]
            continue
    return refs

def analyze(refs, opts):
    names = {}
    multi = {}
    non1st = {}
    issues = {MULTI:multi, NON1ST:non1st}
    analysis = {'REFERENCES':refs, 'ISSUES/PROBLEMS':issues, 
                'RECOMMENDATION':'Please disambiguate references.'}
    for ref in refs:
        if ref.name is not None:
            names[ref.name] = names.get(ref.name, [])+[ref.content]
    for name in names:
        contents = names[name]
        filtered = [content for content in contents if content]
        if len(filtered) > 1:
            multi[name] = []
            for n, content in enumerate(names[name]):
                multi[name].append('[SELECT %s::%s]'% (name,n) + content)
        elif len(contents) > 1 and contents[0] is None:
            non1st[name] = []
            for content in names[name]:
                non1st[name].append(content)
    if not multi and not non1st:
        analysis['RECOMMENDATION'] = 'No problems identified.'
    return analysis

def htmlize(o):
    if isinstance(o, dict):
        print '<dl>'
        for k,v in o.items():
            if v:
                print '<dt><br/>%s</dt>' % k
                print '<dd>', 
                htmlize(v) 
                print '</dd>'
        print '</dl>'
    elif isinstance(o, list):
        print '<ol>'
        for item in o:
            print '<li>',
            htmlize(item)
            print '</li>'
        print '</ol>'
    elif not o:
        print "&lt;EMPTY&gt;"
    elif isinstance(o, (str, unicode)) and o.startswith('[RAW]:'):
        action = modurl+'title='+quote_plus(pageName)+'&action=submit'
        print '<p><b>Check for remaining unresolved issues/problems</b></p>'
        print '<form method="post" action="%s"' % action,
        print 'enctype="multipart/form-data">'
        print '<input type="text" value="%s"' % summary,
        print 'name="wpSummary" id="wpSummary" maxlength="200" size="60" />'
        print '<input type="submit" value="Update using this WikiText"/>'
        print '<textarea name="wpTextbox1" id="wpTextbox1" rows=25 cols=80 style="width:100%">' 
        print o[6:].encode('utf-8')
        print '</textarea></form>'
    elif isinstance(o, (str, unicode)) and o.startswith('[SELECT'):
        end_bracket = o.find(']')
        action = '%s?pageName=%s&action=fix&choice=%s' % (baseurl, 
                    quote_plus(pageName), quote_plus(o[8:end_bracket]))
        print '<a href="%s">[Select]</a> %s' % (action, 
                    o[1+end_bracket:].encode('utf-8'))

    else:
        print o

def summarize(analysis, opts):
    issues = analysis['ISSUES/PROBLEMS']
    has_issues = [issue for issue in issues if issues[issue]]
    output = opts.output.lower()
    if opts.output in ('text','txt'):
        from pprint import pprint
        pprint(analysis)
    elif opts.output == 'html':
        if opts.action.lower() == 'fix':
            print '<h2>Citation analysis of:',
            print '<a href="http://en.wikipedia.org/wiki/%s">%s</a></h2>' \
                   % (quote(opts.pageName), escape(opts.pageName))
        else: 
            print '<h2>Citation analysis of:',
            print '<a href="http://en.wikipedia.org/wiki/%s">%s</a></h2>' \
                   % (quote(opts.pageName), escape(opts.pageName))
        if has_issues:
            fix = '%s?pageName=%s&action=fix' % (baseurl, 
                                                 quote_plus(opts.pageName))
            print '<p><a href="%s">[Attempt automatic fixes]</a></p>' % fix
        if len(analysis['REFERENCES']) == 0:
            print '<p>This article does not use m:Cite.php references.</p>'
            open('pages.log','a').write(opts.pageName+' -\n')
        else:
            htmlize(analysis)
            open('pages.log','a').write(opts.pageName+' +\n')

def dump(txt, pageName="?", output='text'):
    output = output.lower()
    if output in ('text','txt'):
        print txt.encode('utf-8')
    elif output == 'html':
        print '<h2>Raw text of Wikipedia article: %s</h2>' % pageName
        print '<form><textarea rows=40 cols=80 style="width:100%">' 
        print txt.encode("utf-8")
        print '</textarea>'

def fixText(txt, analysis, refs, opts):
    copy = txt[:]
    issues = analysis['ISSUES/PROBLEMS']
    multi = issues[MULTI]
    non1st = issues[NON1ST]
    for refname in non1st.keys():   # Move non-empty to first postition
        reflist = [ref for ref in refs if ref.name==refname]
        with_content = [ref for ref in reflist if ref.content]
        first = txt[reflist[0].start:reflist[0].end]
        filled = txt[with_content[0].start:with_content[0].end]
        copy = copy.replace(filled, first)
        copy = copy.replace(first, filled, 1)
    if opts.choice:             # If an explicit choice of ref is made, use it
        name, choice = opts.choice.split("::")
        empty_ref = '<ref name="%s"/>' % name
        reflist = [ref for ref in refs if ref.name==name]
        with_content = [ref for ref in reflist if ref.content]
        ref = reflist[int(choice)]
        select = txt[ref.start:ref.end]
        for ref in with_content:     # First make all refs empty
            refstr = txt[ref.start:ref.end]
            before = copy.find(refstr)
            after = before + (ref.end-ref.start)
            copy = copy[:before]+empty_ref+copy[after:]
        # Then replace first one with selected content
        copy = copy.replace(empty_ref, select, 1)   
    else:                       # If no choice, remove duplicate content
        for refname in multi.keys(): 
            reflist = [ref for ref in refs if ref.name==refname]
            with_content = [ref for ref in reflist if ref.content]
            filled = txt[with_content[0].start:with_content[0].end]
            empty_ref = '<ref name="%s"/>' % refname
            for ref in reflist:     # First make all refs empty (standard form)
                refstr = txt[ref.start:ref.end]
                copy = copy.replace(refstr, empty_ref)
            # Then replace first one with filled content    
            copy = copy.replace(empty_ref, filled, 1)  
    open('./cache/'+opts.munged_name,'w').write(copy.encode('utf-8'))
    return copy

def get_opts():
    # Quick analysis of arguments and flags
    from optparse import OptionParser
    parser = OptionParser(usage="usage: %prog [options] PAGENAME")
    parser.add_option("-p", "--pageName", dest="pageName", default="",
                       help="Name of Wikipedia page to examine")
    parser.add_option("-o", "--output", dest="output", default="text",
                       help="Output format of analysis (text/html/...)")
    parser.add_option("-x", "--action", dest="action", default="analyze",
                       help="Type of analysis to peform")
    parser.add_option("-c", "--choice", dest="choice",
                       help="Select among multiple named references")
    if len(sys.argv) < 2:
        parser.print_help()
        sys.exit()
    (options, args) = parser.parse_args()
    if options.choice and "::" not in options.choice:
        options.choice = None   # choice must have right form
    if not options.pageName:
        if options.output == 'html' or options.action == 'look_for_refs':
            options.pageName = randomPage()
        elif not args:
            parser.print_help()
            sys.exit()
        else:
            options.pageName = args[0]
    global pageName
    pageName = options.pageName
    return options

if __name__=='__main__':
    opts = get_opts()
    txt = get_raw(opts)
    refs = get_refs(txt)
    if opts.output.lower() == 'html':
        print open('citation_tool.header').read()
        if not opts.pageName:
            print '</body></html>'
            sys.exit()
    
    if opts.action.lower() == 'dump':
        dump(txt, opts.pageName, opts.output)
    elif opts.action.lower() in ('analyze','analyse'):
        analysis = analyze(refs, opts)
        summarize(analysis, opts)
    elif opts.action.lower() == 'fix':
        analysis = analyze(refs, opts)
        txt = fixText(txt, analysis, refs, opts)
        refs = get_refs(txt)
        analysis = analyze(refs, opts)
        analysis['RECOMMENDATION'] = '[RAW]:'+txt
        summarize(analysis, opts)
        # This would auto-modify: DANGER! 
        # -- write_page(txt, opts.pageName)
 
    elif opts.action.lower() == 'look_for_refs':
        import time
        while 1:
            if '<ref' in txt:
                uses_refs = ' +\n'
            else:
                uses_refs = ' -\n'
            try:
                open('pages.log','a').write(opts.pageName+uses_refs)
                opts.pageName = randomPage()
                txt = get_raw(opts)
                time.sleep(45)
            except:
                print "Problem encountered (probably redirect page)"
            
    if opts.output.lower() == 'html':
        print '</body></html>'
