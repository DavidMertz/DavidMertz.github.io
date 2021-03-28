
#
# Test bools (Python 2.3+)
#

import gnosis.xml.pickle as xmp
from gnosis.xml.pickle.util import setVerbose, setParanoia
from funcs import set_parser, unlink

from types import *

# standard test harness setup
set_parser()

class a_test_class:
    def __init__(self):
        pass

def a_test_function():
    pass

class foo:
    def __init__(self):

        self.a = False
        self.b = True
        self.c = None
        self.f = a_test_function
        self.k = a_test_class
        
# always show the family tag so I can make sure it's right
setVerbose(1)
setParanoia(0)

f = foo()

# dump an object containing bools
s = xmp.dumps(f)
print s

x = xmp.loads(s)
print "Expect False, True, None, func, class: ",x.a,x.b,x.c,x.f,x.k

# dump builtin obj containing bools
s = xmp.dumps( (True,False) )
print s

x = xmp.loads( s )
print "Expect True, False: ",x[0],x[1]

# dump bool itself as toplevel obj
s = xmp.dumps( True )
print s

x = xmp.loads(s)
print "Expect True: ",x
