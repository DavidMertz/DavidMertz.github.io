"Test pickling of objects that are subclassed from builtins  --fpm"

import gnosis.xml.pickle as xml_pickle
#from gnosis.util.introspect import hasCoreData
import funcs

funcs.set_parser()

# dummy toplevel class
class top: pass

#
# the "combo" classes contain coredata+attrs
# (they mutate to instances)
#
class lcombo(list):
    def __init__(self,initlist,a,b):
        list.__init__(self,initlist)
        self.a = a
        self.b = b

class dcombo(dict):
    def __init__(self,initdict,a,b):
        dict.__init__(self,initdict)
        self.a = a
        self.b = b

# interesting, Python won't let me define extra args for __init__ ...
# (this leads to the note in setCoreData())
class _tcombo(tuple):
    def __init__(self,inittup):
        tuple.__init__(self,inittup)

def tcombo(inittup,a,b):
    t = _tcombo(inittup)
    t.a = a
    t.b = b
    return t

# ditto for int
class _icombo(int):
    def __init__(self,initi):
        int.__init__(self,initi)

def icombo(initi,a,b):
    i = _fcombo(initi)
    i.a = a
    i.b = b
    return i

# ditto for float
class _fcombo(float):
    def __init__(self,initf):
        float.__init__(self,initf)

def fcombo(initf,a,b):
    f = _fcombo(initf)
    f.a = a
    f.b = b
    return f

# ditto for complex
class _ccombo(complex):
    def __init__(self,initc):
        complex.__init__(self,initc)

def ccombo(initc,a,b):
    c = _ccombo(initc)
    c.a = a
    c.b = b
    return c

# ditto for string
class _scombo(str):
    def __init__(self,inits):
        str.__init__(self,inits)

def scombo(inits,a,b):
    s = _scombo(inits)
    s.a = a
    s.b = b
    return s

# ditto for unicode
class _ucombo(unicode):
    def __init__(self,initu):
        unicode.__init__(self,initu)

def ucombo(initu,a,b):
    s = _ucombo(initu)
    s.a = a
    s.b = b
    return s

#
# the "core" classes are coredata only
# (they mutate to basic types)
#
class lcore(list): pass
class dcore(dict): pass
class tcore(tuple): pass
class icore(int): pass
class locore(long): pass
class fcore(float): pass
class ccore(complex): pass
class score(str): pass
class ucore(unicode): pass

xml_pickle.setParanoia(0)
#xml_pickle.setDeepCopy(1)

#
# test all coredata+attr classes
#
print "* LCOMBO"
x = top()
x.a = lcombo([4,5,6],1,2)
x.a.zz = 10
print x.a, x.a.a, x.a.b, x.a.zz
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a, g.a.a, g.a.b, g.a.zz

print "* DCOMBO"
x = top()
x.a = dcombo({'a':1,'b':2,'c':3},1,2)
x.a.zz = 10
print x.a, x.a.a, x.a.b, x.a.zz
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a, g.a.a, g.a.b, g.a.zz

print "* TCOMBO"
x = top()
x.a = tcombo((10,11,12),1,2)
x.a.zz = 10
print x.a, x.a.a, x.a.b, x.a.zz
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a, g.a.a, g.a.b, g.a.zz

print "* ICOMBO"
x = top()
x.a = fcombo(321,1,2)
x.a.zz = 10
print x.a, x.a.a, x.a.b, x.a.zz
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a, g.a.a, g.a.b, g.a.zz

print "* FCOMBO"
x = top()
x.a = fcombo(5.23,1,2)
x.a.zz = 10
print x.a, x.a.a, x.a.b, x.a.zz
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a, g.a.a, g.a.b, g.a.zz

print "* CCOMBO"
x = top()
x.a = ccombo(234+567j,1,2)
x.a.zz = 10
print x.a, x.a.a, x.a.b, x.a.zz
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a, g.a.a, g.a.b, g.a.zz

print "* SCOMBO"
x = top()
x.a = scombo("a string combo",1,2)
x.a.zz = 10
print x.a, x.a.a, x.a.b, x.a.zz
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a, g.a.a, g.a.b, g.a.zz

print "* UCOMBO"
x = top()
x.a = ucombo(u'a unicode combo',1,2)
x.a.zz = 10
print x.a, x.a.a, x.a.b, x.a.zz
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a, g.a.a, g.a.b, g.a.zz

#
# test all coredata only classes
#
print "* LCORE"
x = top()
x.a = lcore([10,11,12])
print x.a
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a

print "* DCORE"
x = top()
x.a = dcore({'a':1,'b':2,'c':3})
print x.a
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a

print "* TCORE"
x = top()
x.a = tcore((10,11,12))
print x.a
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a

print "* ICORE"
x = top()
x.a = icore(145)
print x.a
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a

print "* LOCORE"
x = top()
x.a = icore(12345L)
print x.a
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a

print "* FCORE"
x = top()
x.a = fcore(123.45)
print x.a
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a

print "* CCORE"
x = top()
x.a = ccore(123+456j)
print x.a
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a

print "* SCORE"
x = top()
x.a = score("hello score")
print x.a
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a

print "* UCORE"
x = top()
x.a = ucore(u"hello ucore")
print x.a
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g.a

# this is brief, but show that toplevels work as
# expected -- i.e. core+attrs == instance-like pickling,
# core+no attrs gets wrapped like a bltin does

print "* toplevel, instance"
x = lcombo([6,7,8],1,2)
print x, x.a, x.b
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print x, x.a, x.b

print "* toplevel, wrapped"
x = lcore([6,7,8])
print x
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g

# check empty containers

print "* empty list"
x = lcore()
print x
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g

print "* empty dict"
x = dcore()
print x
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g

print "* empty tuple"
x = tcore()
print x
s = xml_pickle.dumps(x)
print s
g = xml_pickle.loads(s)
print g



