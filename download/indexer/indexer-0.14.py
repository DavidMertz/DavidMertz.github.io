#!/usr/bin/env python

"""Create full-text indexes and search them

Note:

  See http://gnosis.cx/publish/programming/charming_python_15.txt
  for a detailed discussion of this module.

Classes:

    GenericIndexer      -- Abstract class
    TextSplitter        -- Mixin class
    ShelveIndexer
    FlatIndexer
    XMLPickleIndexer
    PickleIndexer
    ZPickleIndexer
    SlicedZPickleIndexer

Functions:

    echo_fname(fname)
    recurse_files(...)

Index Formats:

    *Indexer.files:     filename --> (fileid, wordcount)
    *Indexer.fileids:   fileid --> filename
    *Indexer.words:     word --> {fileid1:occurs, fileid2:occurs, ...}

Module Usage:

  There are a few ways to use this module.  Just to utilize existing
  functionality, something like the following is a likely
  pattern:

      import indexer
      index = indexer.MyFavoriteIndexer()     # For some concrete Indexer
      index.load_index('myIndex.db')
      index.add_files(dir='/this/that/otherdir', pattern='*.txt')
      hits = index.find(['spam','eggs','bacon'])
      index.print_report(hits)

  To customize the basic classes, something like the following is likely:

      class MySplitter:
          def splitter(self, text, ftype):
              "Peform much better splitting than default (for filetypes)"
              # ...
              return words

      class MyIndexer(indexer.GenericIndexer, MySplitter):
          def load_index(self, INDEXDB=None):
              "Retrieve three dictionaries from clever storage method"
              # ...
              self.words, self.files, self.fileids = WORDS, FILES, FILEIDS
          def save_index(self, INDEXDB=None):
              "Save three dictionaries to clever storage method"

      index = MyIndexer()
      # ...etc...

Benchmarks:

  As we know, there are lies, damn lies, and benchmarks.  Take
  the below with an adequate dose of salt.  In version 0.10 of
  the concrete indexers, some performance was tested.  The
  test case was a set of mail/news archives, that were about
  43 mB, and 225 files.  In each case, an index was generated
  (if possible), and a search for the words "xml python" was
  performed.

    - Index w/ PickleIndexer:     482s, 2.4 mB
    - Search w/ PickleIndexer:    1.74s
    - Index w/ ZPickleIndexer:    484s, 1.2 mB
    - Search w/ ZPickleIndexer:   1.77s
    - Index w/ FlatIndexer:       492s, 2.6 mB
    - Search w/ FlatIndexer:      53s
    - Index w/ ShelveIndexer:     (dumbdbm) Many minutes, tens of mBs
    - Search w/ ShelveIndexer:    Aborted before completely indexed
    - Index w/ ShelveIndexer:     (dbhash) Long time (partial crash), 10 mB
    - Search w/ ShelveIndexer:    N/A. Too many glitches
    - Index w/ XMLPickleIndexer:  Memory error (xml_pickle uses bad string
                                                composition for large output)
    - Search w/ XMLPickleIndexer: N/A
    - grep search (xml|python):   20s (cached: <5s)
    - 'srch' utility (python):    12s
"""
__shell_usage__ = """
Shell Usage: [python] indexer.py [options] [search_words]

    -h, /h, -?, /?, ?, --help:    Show this help screen
    -index:                       Add files to index
    -reindex:                     Refresh files already in the index
                                  (can take much more time)
    -casesensitive:               Maintain the case of indexed words
                                  (can lead to MUCH larger indices)
    -norecurse, -local:           Only index starting dir, not subdirs
    -dir=<directory>:             Starting directory for indexing
                                  (default is current directory)
    -indexdb=<database>:          Use specified index database
                                  (environ variable INDEXER_DB is preferred)
    -regex=<pattern>:             Index files matching regular expression
    -glob=<pattern>:              Index files matching glob pattern
    -output=<op>, -format=<opt>:  How much detail on matches?
    -<digit>:                     Quiet level (0=verbose ... 9=quiet)

Output/format options are ALL/EVERYTHING/VERBOSE, RATINGS/SCORES,
FILENAMES/NAMES/FILES, SUMMARY/REPORT"""

__version__ = "$Revision: 0.14 $"
__author__=["David Mertz (mertz@gnosis.cx)",]
__thanks_to__=["Pat Knight (p.knight@ktgroup.co.uk)",]
__copyright__="""
    This file is released to the public domain.  I (dqm) would
    appreciate it if you choose to keep derived works under terms
    that promote freedom, but obviously am giving up any rights
    to compel such.
"""

__history__="""
    0.1    Initial version.

    0.11   Tweaked TextSplitter after some random experimentation.

    0.12   Added SlicedZPickleIndexer (best choice, so far).

    0.13   Pat Knight pointed out need for binary open()'s of
           certain files under Windows.

    0.14   Added '-filter' switch to search results.
"""

import string, re, os, fnmatch, sys, copy
from types import *

#-- Silly "do nothing" default recursive file processor
def echo_fname(fname): print fname

#-- "Recurse and process files" utility function
def recurse_files(curdir, pattern, exclusions, func=echo_fname, *args, **kw):
    "Recursively process file pattern"
    subdirs, files = [],[]
    level = kw.get('level',0)

    for name in os.listdir(curdir):
        fname = os.path.join(curdir, name)
        if name[-4:] in exclusions:
            pass            # do not include binary file type
        elif os.path.isdir(fname) and not os.path.islink(fname):
            subdirs.append(fname)
        # kludge to detect a regular expression across python versions
        elif sys.version[0]=='1' and isinstance(pattern, re.RegexObject):
            if pattern.match(name):
                files.append(fname)
        elif sys.version[0]=='2' and type(pattern)==type(re.compile('')):
            if pattern.match(name):
                files.append(fname)
        elif type(pattern) is StringType:
            if fnmatch.fnmatch(name, pattern):
                files.append(fname)

    for fname in files:
        apply(func, (fname,)+args)
    for subdir in subdirs:
        recurse_files(subdir, pattern, exclusions, func, level=level+1)

#-- "Split plain text into words" utility function
common_words = {'THE':1, 'ABOUT':1, 'WHEN':1, 'ARE':1, 'HAVE':1,
                'AND':1, 'YOU':1, 'THIS':1, 'WAS':1, 'THAT':1,
                'HAS':1, 'FOR':1, 'WITH':1, 'NOT':1, 'FROM':1}
prenum  = string.join(map(chr, range(0,48)))
num2cap = string.join(map(chr, range(58,65)))
cap2low = string.join(map(chr, range(91,97)))
postlow = string.join(map(chr, range(123,256)))
nonword = prenum+num2cap+cap2low+postlow
word_only = string.maketrans(nonword, " "*len(nonword))

class TextSplitter:
    def splitter(self, text, ftype):
        "Split the contents of a text string into a list of 'words'"
        if ftype == 'text/plain':
            words = self.text_splitter(text, self.casesensitive)
        else:
            raise NotImplementedError
        return words

    def text_splitter(self, text, casesensitive=0):
        """Split text/plain string into a list of words

        In version 0.12 this function is still fairly weak at
        identifying "real" words, and excluding gibberish
        strings.  As long as the indexer looks at "real" text
        files, it does pretty well; but if indexing of binary
        data is attempted, a lot of gibberish gets indexed.
        Suggestions on improving this are GREATLY APPRECIATED.
        """
        translate = string.translate

        # Let's adjust case if not case-sensitive
        if not casesensitive:
            text = string.upper(text)

        # Split the raw text
        allwords = string.split(text)

        # Finally, let's skip some words not worth indexing
        words = []
        for word in allwords:
            if len(word) > 25: continue         # too long (probably gibberish)
            if self.isGibberish(word): continue # sets off gibberish detector
            word = translate(word, word_only)   # Let's strip funny byte values
            subwords = string.split(word)       # maybe embedded non-alphanumeric
            for subword in subwords:            # ...so we might have subwords
                if len(subword) <= 2: continue  # too short a subword
                #if common_words.has_key(word): # too common a subword
                #    continue
                words.append(subword)
        return words

    def isGibberish(self, word):
        "Identify some common patterns in non-word data (binary, UU/MIME, etc)"
        num_nonalpha = 0
        numdigits = 0
        for c in word:
            if c in string.digits+nonword:
                num_nonalpha = num_nonalpha+1
            if c in string.digits:
                numdigits = numdigits+1
        if numdigits > len(word)-2:          # almost all digits
            if numdigits > 5: return 1       # too many digits is gibberish
            else: return 0                   # but a moderate number is year/zipcode/etc
        if num_nonalpha*3 > len(word):       # too much scattered nonalpha is gibberish
            return 1
        return 0

#-- "Abstract" parent class for inherited indexers
#   (does not handle storage in parent, other methods are primitive)

class GenericIndexer:
    def __init__(self, **kw):
        apply(self.configure, (), kw)

    def whoami(self):
        return self.__class__.__name__

    def configure(self, REINDEX=0, CASESENSITIVE=0,
                        INDEXDB=os.environ.get('INDEXER_DB', 'TEMP_NDX.DB'),
                        ADD_PATTERN='*', QUIET=5):
        "Configure settings used by indexing and storage/retrieval"
        self.indexdb = INDEXDB
        self.reindex = REINDEX
        self.casesensitive = CASESENSITIVE
        self.add_pattern = ADD_PATTERN
        self.quiet = QUIET
        self.filter = None

    def add_files(self, dir=os.getcwd(), pattern=None, descend=1):
        self.load_index()
        exclusions = ('.zip','.pyc','.gif','.jpg','.dat','.dir')
        if not pattern:
             pattern = self.add_pattern
        recurse_files(dir, pattern, exclusions, self.add_file)
        # Rebuild the fileid index
        self.fileids = {}
        for fname in self.files.keys():
            fileid = self.files[fname][0]
            self.fileids[fileid] = fname

    def add_file(self, fname, ftype='text/plain'):
        "Index the contents of a regular file"
        if self.files.has_key(fname):   # Is file eligible for (re)indexing?
            if self.reindex:            # Reindexing enabled, cleanup dicts
                self.purge_entry(fname, self.files, self.words)
            else:                   # DO NOT reindex this file
                if self.quiet < 5: print "Skipping", fname
                return 0

        # Read in the file (if possible)
        try:
            text = open(fname).read()
            if self.quiet < 5: print "Indexing", fname
        except IOError:
            return 0
        words = self.splitter(text, ftype)

        # Find new file index, and assign it to filename
        # (_TOP uses trick of negative to avoid conflict with file index)
        self.files['_TOP'] = (self.files['_TOP'][0]-1, None)
        file_index =  abs(self.files['_TOP'][0])
        self.files[fname] = (file_index, len(words))

        for word in words:
            if self.words.has_key(word):
                entry = self.words[word]
            else:
                entry = {}
            if entry.has_key(file_index):
                entry[file_index] = entry[file_index]+1
            else:
                entry[file_index] = 1
            self.words[word] = entry

    def add_othertext(self, identifier):
        """Index a textual source other than a plain file

        A child class might want to implement this method (or a similar one)
        in order to index textual sources such as SQL tables, URLs, clay
        tablets, or whatever else.  The identifier should uniquely pick out
        the source of the text (whatever it is)
        """
        raise NotImplementedError

    def save_index(self, INDEXDB=None):
        raise NotImplementedError

    def load_index(self, INDEXDB=None, reload=0, wordlist=None):
        raise NotImplementedError

    def find(self, wordlist, print_report=0):
        "Locate files that match ALL the words in wordlist"
        self.load_index(wordlist=wordlist)
        entries = {}
        hits = copy.copy(self.fileids)      # Copy of fileids index
        for word in wordlist:
            if not self.casesensitive:
                word = string.upper(word)
            entry = self.words.get(word)    # For each word, get index
            entries[word] = entry           #   of matching files
            if not entry:                   # Nothing for this one word (fail)
                return 0
            for fileid in hits.keys():      # Eliminate hits for every non-match
                if not entry.has_key(fileid):
                    del hits[fileid]
        if print_report:
            self.print_report(hits, wordlist)
        return hits

    def print_report(self, hits={}, wordlist=[]):
        # Figure out what to actually print (based on QUIET level)
        output = []
        for fileid,fname in hits.items():
            message = fname
            if self.quiet <= 3:
                wordcount = self.files[fname][1]
                matches = 0
                countmess = '\n'+' '*13+`wordcount`+' words; '
                for word in wordlist:
                    if not self.casesensitive:
                        word = string.upper(word)
                    occurs = entries[word][fileid]
                    matches = matches+occurs
                    countmess = countmess +`occurs`+' '+word+'; '
                message = string.ljust('[RATING: '
                                       +`1000*matches/wordcount`+']',13)+message
                if self.quiet <= 2: message = message +countmess +'\n'
            if self.filter:     # Using an output filter
                if fnmatch.fnmatch(message, self.filter):
                    output.append(message)
            else:
                output.append(message)

        if self.quiet <= 5:
            print string.join(output,'\n')
        sys.stderr.write('\n'+`len(output)`+' files matched wordlist: '+
                         `wordlist`+'\n')
        return output

    def purge_entry(self, fname, file_dct, word_dct):
        "Remove a file from file index and word index"
        try:        # The easy part, cleanup the file index
            file_index = file_dct[fname]
            del file_dct[fname]
        except KeyError:
            pass    # We'll assume we only encounter KeyError's
        # The much harder part, cleanup the word index
        for word, occurs in word_dct.items():
            if occurs.has_key(file_index):
                del occurs[file_index]
                word_dct[word] = occurs


#-- Provide an actual storage facility for the indexes (i.e. shelve)
class ShelveIndexer(GenericIndexer, TextSplitter):
    """Concrete Indexer utilizing [shelve] for storage

    Unfortunately, [shelve] proves far too slow in indexing, while
    creating monstrously large indexes.  Not recommend, at least under
    the default dbm's tested.  Also, class may be broken because
    shelves do not, apparently, support the .values() and .items()
    methods.  Fixing this is a low priority, but the sample code is
    left here.
    """
    def load_index(self, INDEXDB=None, reload=0, wordlist=None):
        INDEXDB = INDEXDB or self.indexdb
        import shelve
        self.words   = shelve.open(INDEXDB+".WORDS")
        self.files   = shelve.open(INDEXDB+".FILES")
        self.fileids = shelve.open(INDEXDB+".FILEIDS")
        if not FILES:            # New index
            self.files['_TOP'] = (0,None)

    def save_index(self, INDEXDB=None):
        INDEXDB = INDEXDB or self.indexdb
        pass

class FlatIndexer(GenericIndexer, TextSplitter):
    """Concrete Indexer utilizing flat-file for storage

    See the comments in the referenced article for details; in
    brief, this indexer has about the same timing as the best in
    -creating- indexes and the storage requirements are
    reasonable.  However, actually -using- a flat-file index is
    more than an order of magnitude worse than the best indexer
    (ZPickleIndexer wins overall).

    On the other hand, FlatIndexer creates a wonderfully easy to
    parse database format if you have a reason to transport the
    index to a different platform or programming language.  And
    should you perform indexing as part of a long-running
    process, the overhead of initial file parsing becomes
    irrelevant.
    """
    def load_index(self, INDEXDB=None, reload=0, wordlist=None):
        # Unless reload is indicated, do not load twice
        if reload: pass
        elif ( hasattr(self,'fileids') and
               hasattr(self,'files') and
               hasattr(self,'words') ):
            return 0
        # Ok, now let's actually load it
        INDEXDB = INDEXDB or self.indexdb
        self.words = {}
        self.files = {'_TOP':(0,None)}
        self.fileids = {}
        try:                            # Read index contents
            for line in open(INDEXDB).readlines():
                fields = string.split(line)
                if fields[0] == '-':    # Read a file/fileid line
                    fileid = eval(fields[2])
                    wordcount = eval(fields[3])
                    fname = fields[1]
                    self.files[fname] = (fileid, wordcount)
                    self.fileids[fileid] = fname
                else:                   # Read a word entry (dict of hits)
                    entries = {}
                    word = fields[0]
                    for n in range(1,len(fields),2):
                        fileid = eval(fields[n])
                        occurs = eval(fields[n+1])
                        entries[fileid] = occurs
                    self.words[word] = entries
        except:
            pass                    # New index

    def save_index(self, INDEXDB=None):
        INDEXDB = INDEXDB or self.indexdb
        tab, lf, sp = '\t','\n',' '
        indexdb = open(INDEXDB,'w')
        for fname,entry in self.files.items():
            indexdb.write('- '+fname +tab +`entry[0]` +tab +`entry[1]` +lf)
        for word,entry in self.words.items():
            indexdb.write(word +tab+tab)
            for fileid,occurs in entry.items():
                indexdb.write(`fileid` +sp +`occurs` +sp)
            indexdb.write(lf)

class Index: pass
class PickleIndexer(GenericIndexer, TextSplitter):
    def load_index(self, INDEXDB=None, reload=0, wordlist=None):
        # Unless reload is indicated, do not load twice
        if reload: pass
        elif ( hasattr(self,'fileids') and
               hasattr(self,'files') and
               hasattr(self,'words') ):
            return 0
        # Ok, now let's actually load it
        import cPickle
        INDEXDB = INDEXDB or self.indexdb
        try:
            pickle_str =  open(INDEXDB,'rb').read()
            db = cPickle.loads(pickle_str)
        except:                     # New index
            db = Index()
            db.WORDS = {}
            db.FILES = {'_TOP':(0,None)}
            db.FILEIDS = {}
        self.words, self.files, self.fileids = db.WORDS, db.FILES, db.FILEIDS

    def save_index(self, INDEXDB=None):
        import cPickle
        INDEXDB = INDEXDB or self.indexdb
        db = Index()
        db.WORDS   = self.words
        db.FILES   = self.files
        db.FILEIDS = self.fileids
        pickle_str = cPickle.dumps(db, 1)
        pickle_fh = open(INDEXDB,'wb')
        pickle_fh.write(pickle_str)

class XMLPickleIndexer(PickleIndexer):
    """Concrete Indexer utilizing XML for storage

    While this is, as expected, a verbose format, the possibility
    of using XML as a transport format for indexes might be
    useful.  However, [xml_pickle] is in need of some redesign to
    avoid gross inefficiency when creating very large
    (multi-megabyte) output files (should be done by [xml_pickle]
    version 0.4 or above)
    """
    def load_index(self, INDEXDB=None, reload=0, wordlist=None):
        # Unless reload is indicated, do not load twice
        if reload: pass
        elif ( hasattr(self,'fileids') and
               hasattr(self,'files') and
               hasattr(self,'words') ):
            return 0
        # Ok, now let's actually load it
        from xml_pickle import XML_Pickler
        INDEXDB = INDEXDB or self.indexdb
        try:                        # XML file exists
            xml_str = open(INDEXDB).read()
            db = XML_Pickler().loads(xml_str)
        except:                     # New index
            db = Index()
            db.WORDS = {}
            db.FILES = {'_TOP':(0,None)}
            db.FILEIDS = {}
        self.words, self.files, self.fileids = db.WORDS, db.FILES, db.FILEIDS

    def save_index(self, INDEXDB=None):
        from xml_pickle import XML_Pickler
        INDEXDB = INDEXDB or self.indexdb
        db = Index()
        db.WORDS   = self.words
        db.FILES   = self.files
        db.FILEIDS = self.fileids
        open(INDEXDB,'w').write(XML_Pickler(db).dumps())

class ZPickleIndexer(PickleIndexer):
    def load_index(self, INDEXDB=None, reload=0, wordlist=None):
        # Unless reload is indicated, do not load twice
        if reload: pass
        elif ( hasattr(self,'fileids') and
               hasattr(self,'files') and
               hasattr(self,'words') ):
            return 0
        # Ok, now let's actually load it
        import cPickle, zlib
        INDEXDB = INDEXDB or self.indexdb
        try:
            pickle_str =  zlib.decompress(open(INDEXDB+'!','rb').read())
            db = cPickle.loads(pickle_str)
        except:                     # New index
            db = Index()
            db.WORDS = {}
            db.FILES = {'_TOP':(0,None)}
            db.FILEIDS = {}
        self.words, self.files, self.fileids = db.WORDS, db.FILES, db.FILEIDS

    def save_index(self, INDEXDB=None):
        import cPickle, zlib
        INDEXDB = INDEXDB or self.indexdb
        db = Index()
        db.WORDS   = self.words
        db.FILES   = self.files
        db.FILEIDS = self.fileids
        pickle_str = cPickle.dumps(db, 1)
        pickle_fh = open(INDEXDB+'!','wb')
        pickle_fh.write(zlib.compress(pickle_str))

class SlicedZPickleIndexer(ZPickleIndexer):
    segments = "ABCDEFGHIJKLMNOPQRSTUVWXYZ#-!"
    def load_index(self, INDEXDB=None, reload=0, wordlist=None):
        # Unless reload is indicated, do not load twice
        if reload: pass
        elif ( hasattr(self,'fileids') and
               hasattr(self,'files') and
               hasattr(self,'words') ):
            return 0
        # Ok, now let's actually load it
        import cPickle, zlib
        INDEXDB = INDEXDB or self.indexdb
        db = Index()
        db.WORDS = {}
        db.FILES = {'_TOP':(0,None)}
        db.FILEIDS = {}
        # Identify the relevant word-dictionary segments
        if not wordlist:
            segments = self.__class__.segments
        else:
            segments = ['-','#']
            for word in wordlist:
                segments.append(string.upper(word[0]))
        # Load the segments
        for segment in segments:
            try:
                pickle_str = zlib.decompress(open(INDEXDB+segment,'rb').read())
                dbslice = cPickle.loads(pickle_str)
                if hasattr(dbslice, 'WORDS'):   # If it has some words, add them
                    for word,entry in dbslice.WORDS.items():
                        db.WORDS[word] = entry
                if hasattr(dbslice, 'FILES'):   # If it has some files, add them
                    db.FILES = dbslice.FILES
                if hasattr(dbslice, 'FILEIDS'): # If it has fileids, add them
                    db.FILEIDS = dbslice.FILEIDS
            except:
                pass    # No biggie, couldn't find this segment
        self.words, self.files, self.fileids = db.WORDS, db.FILES, db.FILEIDS

    def julienne(self, INDEXDB=None):
        import cPickle, zlib
        INDEXDB = INDEXDB or self.indexdb
        segments = self.__class__.segments       # all the (little) indexes
        for segment in segments:
            try:        # brutal space saver... delete all the small segments
                os.remove(INDEXDB+segment)
            except OSError:
                pass    # probably just nonexistent segment index file
        # First write the much simpler filename/fileid dictionaries
        dbfil = Index()
        dbfil.FILES = self.files
        dbfil.FILEIDS = self.fileids
        open(INDEXDB+'-','wb').write(zlib.compress(cPickle.dumps(dbfil,1)))
        # The hard part is splitting the word dictionary up, of course
        letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        segdicts = {}                           # Need batch of empty dicts
        for segment in letters+'#':
            segdicts[segment] = {}
        for word, entry in self.words.items():  # Split into segment dicts
            initchar = string.upper(word[0])
            if initchar in letters:
                segdicts[initchar][word] = entry
            else:
                segdicts['#'][word] = entry
        for initchar in letters+'#':
            db = Index()
            db.WORDS = segdicts[initchar]
            pickle_str = cPickle.dumps(db, 1)
            pickle_fh = open(INDEXDB+initchar,'wb')
            pickle_fh.write(zlib.compress(pickle_str))

    save_index = julienne

PreferredIndexer = SlicedZPickleIndexer

#-- If called from command-line, parse arguments and take actions
if __name__ == '__main__':
    import time
    start = time.time()
    search_words = []           # Word search list (if specified)
    opts = 0                    # Any options specified?
    if len(sys.argv) < 2:
        pass                    # No options given
    else:
        upper = string.upper
        dir = os.getcwd()       # Default to indexing from current directory
        descend = 1             # Default to recursive indexing
        ndx = PreferredIndexer()
        for opt in sys.argv[1:]:
            if opt in ('-h','/h','-?','/?','?','--help'):   # help screen
                print __shell_usage__
                opts = -1
                break
            elif opt[0] in '/-':                            # a switch!
                opts = opts+1
                if upper(opt[1:]) == 'INDEX':               # Index files
                    ndx.quiet = 0
                    pass     # Use defaults if no other options
                elif upper(opt[1:]) == 'REINDEX':           # Reindex
                    ndx.reindex = 1
                elif upper(opt[1:]) == 'CASESENSITIVE':     # Case sensitive
                    ndx.casesensitive = 1
                elif upper(opt[1:]) in ('NORECURSE','LOCAL'): # No recursion
                    descend = 0
                elif upper(opt[1:4]) == 'DIR':              # Dir to index
                    dir = opt[5:]
                elif upper(opt[1:8]) == 'INDEXDB':          # Index specified
                    ndx.indexdb = opt[9:]
                    sys.stderr.write(
                        "Use of INDEXER_DB environment variable is STRONGLY recommended.\n")
                elif upper(opt[1:6]) == 'REGEX':            # RegEx files to index
                    ndx.add_pattern = re.compile(opt[7:])
                elif upper(opt[1:5]) == 'GLOB':             # Glob files to index
                    ndx.add_pattern = opt[6:]
                elif upper(opt[1:7]) in ('OUTPUT','FORMAT'): # How should results look?
                    opts = opts-1   # this is not an option for indexing purposes
                    level = upper(opt[8:])
                    if level in ('ALL','EVERYTHING','VERBOSE', 'MAX'):
                        ndx.quiet = 0
                    elif level in ('RATINGS','SCORES','HIGH'):
                        ndx.quiet = 3
                    elif level in ('FILENAMES','NAMES','FILES','MID'):
                        ndx.quiet = 5
                    elif level in ('SUMMARY','MIN'):
                        ndx.quiet = 9
                elif upper(opt[1:7]) == 'FILTER':           # Regex filter output
                    opts = opts-1   # this is not an option for indexing purposes
                    ndx.filter = opt[8:]
                elif opt[1:] in string.digits:
                    opts = opts-1
                    ndx.quiet = eval(opt[1])
            else:
                search_words.append(opt)                    # Search words

    if opts > 0:
        ndx.add_files(dir=dir)
        ndx.save_index()
    if search_words:
        ndx.find(search_words, print_report=1)
    if not opts and not search_words:
        sys.stderr.write("Perhaps you would like to use the --help option?\n")
    else:
        sys.stderr.write('Processed in %.3f seconds (%s)'
                          % (time.time()-start, ndx.whoami()))

