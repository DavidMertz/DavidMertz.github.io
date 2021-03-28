"Test rawpickles by turning off mxDateTime extension  --fpm"

import mx.DateTime as date
import UserList, UserDict
from types import *
import gnosis.xml.pickle as xml_pickle
import gnosis.xml.pickle.ext as xml_pickle_ext
from gnosis.xml.pickle.util import setParanoia
from gnosis.xml.pickle.ext._mutate import __disable_extensions
from gnosis.xml.pickle.ext import mutate
import funcs

funcs.set_parser()

class foo_class:
    def __init__(self):
        pass

    def hi(self):
        print "Hello foo"

def printfoo(obj):
    print type(obj.t), obj.t
    print type(obj.d), obj.d['One'], obj.d['Two']
    print type(obj.ud), obj.ud['One'], obj.ud['Two']
    print type(obj.l), obj.l[0], obj.l[1]
    print type(obj.ul), obj.ul[0], obj.ul[1]
    print type(obj.tup), obj.tup[0], obj.tup[1]

foo = foo_class()

# allow imported classes to be restored
setParanoia(0)

# test both code paths

# path 1 - non-nested ('attr' nodes)
foo.t = date.DateTime(2000,1,2,3,4,5.6)

# path 2 - nested ('item/key/val' nodes)
foo.d = { 'One': date.DateTime(2001,2,3,4,5,6.7),
          'Two': date.DateTime(2002,3,4,5,6,7.8) }

foo.ud = UserDict.UserDict()
foo.ud['One'] = date.DateTime(2003,4,5,6,7,8.9)
foo.ud['Two'] = date.DateTime(2004,5,6,7,8,9.10)

foo.l = []
foo.l.append( date.DateTime(2005,6,7,8,9,10.11) )
foo.l.append( date.DateTime(2006,7,8,9,10,11.12) )

foo.ul = UserList.UserList()
foo.ul.append( date.DateTime(2007,8,9,10,11,12.13) )
foo.ul.append( date.DateTime(2008,9,10,11,12,13.14) )

foo.tup = (date.DateTime(2009,10,11,12,13,14.15),
           date.DateTime(2010,11,12,13,14,15.16))

print "---PRE-PICKLE---"
printfoo(foo)

__disable_extensions()

x1 = xml_pickle.XML_Pickler(foo).dumps()
#print x1

print "---POST-PICKLE---"
bar = xml_pickle.XML_Pickler().loads(x1)
printfoo(bar)
bar.hi()

x2 = xml_pickle.XML_Pickler(bar).dumps()

print "---XML from original---"
print x1

print "---XML from copy---"
print x2

