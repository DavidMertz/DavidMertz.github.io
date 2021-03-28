# show that mixins works  --fpm
#

import gnosis.xml.pickle as xml_pickle
from gnosis.xml.pickle import XML_Pickler
from gnosis.xml.pickle.util import setParanoia
from UserList import UserList
import funcs

funcs.set_parser()

class Foo:
    def hi(self):
        print self.hello()

    def hello(self):
        return "FOO!"

class Bar(Foo,XML_Pickler):

    def __init__(self):
        XML_Pickler.__init__(self)

    def hello(self):
        return "BAR!"

class Bat(Foo,XML_Pickler):

    def __init__(self):
        XML_Pickler.__init__(self)

    def hello(self):
        return "BAT!"

class FunList(UserList,XML_Pickler):
    def __init__(self):
        XML_Pickler.__init__(self)
        UserList.__init__(self)
    pass

# allow xml_pickle to use our imports
setParanoia(0)

l = FunList()
l.append(Foo())
l.append(Bar())
l.append(Bat())

for n in l:
    n.hi()

s = l.dumps()
print s

x = XML_Pickler().loads(s)

for n in x:
    n.hi()





