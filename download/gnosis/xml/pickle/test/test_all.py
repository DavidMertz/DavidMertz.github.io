"""
generic test harness - runs "all" the test_*.py files and
writes the output to TESTS.OUT-{pyversion}

-- frankm@hiwaay.net
"""

import os,sys,string
from time import time
from gnosis.xml.pickle.util import enumParsers
import funcs

# use same python that we're running under
py = sys.executable

# these are ordered (roughly) from simplest->hardest, in terms
# of sophistication of the parser -- ie. when building a new
# parser, you might want to build up capability in this order

# NOTE! Not *ALL* test_*.py files are suitable for a batch run,
# so we list the tests we want
_ = """
    bltin
    basic
    mixin
    compat
    ftypes
    getstate
    getinitargs
    init
    modnames
    objectify
    paranoia
    mutators
    rawp_sre
    re
    ref
    selfref
    unicode
    bools_ro
"""
tests = ['test_%s.py' % t for t in _.split()]

if funcs.pyver() >= '2.3':
    # tests requiring Python >= 2.3
    tests.append('test_bools.py')
else:
    print "** OMITTING test_bools.py"
    
if funcs.pyver() >= '2.2':
    # tests requiring Python >= 2.2
    tests.append('test_subbltin.py')
    tests.append('test_slots.py')
else:
    print "** OMITTING test_subbltin.py"
    print "** OMITTING test_slots.py"

try:
    import gzip
    tests.append('test_4list.py')
except:
    print "** OMITTING test_4list (missing zlib) **"

# if mx.DateTime installed, add those tests
try:
    import mx.DateTime
    tests.append('test_mx.py')
    tests.append('test_rawp_mx.py')
except:
    print "** OMITTING test_mx.py & test_rawp_mx.py"

# if Random works, add setstate test
try:
    import random
    r = random.Random()
    #---begin bug check---
    # XXX as of Python 2.3b1, pickle of Randoms is broken.
    # remove this test as soon as it is fixed (note that
    # test_getstate also tests __setstate__, so I think
    # we still have complete coverage, but this test
    # is nice too since it's somewhat different)
    import pickle
    pickle.dumps(r)
    #---end bug check---
    
    tests.append('test_setstate.py')
except:
    print "** OMITTING test_setstate.py"

# if Numeric installed, add numpy test
try:
    import Numeric
    tests.append('test_numpy.py')
except:
    print "** OMITTING test_numpy.py"

from funcs import unlink, touch

def echof(filename,line):
    if os.path.isfile(filename):
        f = open(filename,'a')
    else:
        f = open(filename,'w')

    f.write(line+'\n')

#tout = 'TESTS.OUT-%s' % os.path.split(py)[-1]
tout = 'TESTS.OUT-%s-%s' % (sys.platform,sys.version.split()[0])

unlink(tout)
touch(tout)

# get available parsers
parser_dict = enumParsers()

# test with DOM parser, if available
if parser_dict.has_key('DOM'):

    # make sure the USE_.. files are gone
    unlink("USE_SAX")
    unlink("USE_CEXPAT")

    t1 = time()

    for test in tests:
        print "Running %s" % test
        echof(tout,"** %s %s DOM PARSER **" % (py,test))
        r = os.system("%s %s >> %s"%(py,test,tout))
        if r != 0:
            print "***ERROR***"
            sys.exit(1)

    print "%.1f seconds" % (time()-t1)
else:
    print "** SKIPPING DOM parser **"

# test with SAX parser, if available
if parser_dict.has_key("SAX"):

    touch("USE_SAX")

    t1 = time()

    for test in tests:
        print "Running %s" % test
        echof(tout,"** %s %s SAX PARSER **" % (py,test))
        r = os.system("%s %s >> %s"%(py,test,tout))
        if r != 0:
            print "***ERROR***"
            sys.exit(1)

    print "%.1f seconds" % (time()-t1)

    unlink("USE_SAX");
else:
    print "** SKIPPING SAX parser **"

# test with cEXPAT parser, if available
if parser_dict.has_key("cEXPAT"):

    touch("USE_CEXPAT");

    t1 = time()

    for test in tests:
        print "Running %s" % test
        echof(tout,"** %s %s CEXPAT PARSER **" % (py,test))
        r = os.system("%s %s >> %s"%(py,test,tout))
        if r != 0:
            print "***ERROR***"
            sys.exit(1)

    print "%.1f seconds" % (time()-t1)

    unlink("USE_CEXPAT");
else:
    print "** SKIPPING cEXPAT parser **"
