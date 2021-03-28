
import gnosis.xml.pickle as xml_pickle

import funcs

funcs.set_parser()

class foo(object):
    __slots__ = ('a','b')

xml_pickle.setParanoia(0)

f = foo()
f.a = 1
f.b = 2
print f.a, f.b

s = xml_pickle.dumps(f)
print s

g = xml_pickle.loads(s)
print g.a, g.b




