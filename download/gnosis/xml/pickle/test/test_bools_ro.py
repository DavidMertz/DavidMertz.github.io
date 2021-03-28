
# read-only version of bool test.
# show that bools are converted to the "best" value, depending
# on Python version being used. --fpm

import gnosis.xml.pickle as xmp
from gnosis.xml.pickle.util import setVerbose, setParser, setParanoia
from funcs import set_parser, unlink, pyver

from types import *

s = """<?xml version="1.0"?>
<!DOCTYPE PyObject SYSTEM "PyObjects.dtd">
<PyObject module="__main__" class="foo" id="1078562444">
<attr name="a" family="uniq" type="False" value="" />
<attr name="b" family="uniq" type="True" value="" />
</PyObject>"""

# it'll create a class for loading - only care about the vals here
x = xmp.loads(s)

if pyver() >= '2.3':
    print "Expect False, True: ", x.a, x.b
else:
    print "Expect 0, 1: ", x.a, x.b 

