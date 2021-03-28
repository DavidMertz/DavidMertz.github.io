"Demonstrate on-the-fly and gnosis.xml.* namespaces not saved in XML file"

import gnosis.xml.pickle as xml_pickle
from UserList import UserList
import funcs

funcs.set_parser()

ud_xml = """<?xml version="1.0"?>
<!DOCTYPE PyObject SYSTEM "PyObjects.dtd">
<PyObject module="__main__" class="Foo">
</PyObject>
"""

class myfoo: pass
class Foo: pass

print "On-the-fly -- SHOULD *NOT* SEE MODULE NAME IN XML"
p = xml_pickle.loads(ud_xml)
# print it so we can see the modname
print "Fullname = "+str(p)

# write it to make sure modname doesn't stick
s = xml_pickle.dumps(p)
print s

print "From (old) xml_pickle namespace -- SHOULD *NOT* SEE MODULE NAME IN XML"
xml_pickle.Foo = myfoo
p = xml_pickle.loads(ud_xml)
# print it so we can see the modname
print "Fullname = "+str(p)

# write it to make sure modname doesn't stick
s = xml_pickle.dumps(p)
print s

del xml_pickle.Foo

xml_pickle.add_class_to_store('Foo',myfoo)

print "From class store -- SHOULD *NOT* SEE MODULE NAME IN XML"
p = xml_pickle.loads(ud_xml)
# print it so we can see the modname
print "Fullname = "+str(p)

# write it to make sure modname doesn't stick
s = xml_pickle.dumps(p)
print s

xml_pickle.remove_class_from_store('Foo')

# now, make sure we haven't broken modnames showing up when they SHOULD :-)
print "My namespace (__main__) -- SHOULD SEE MODULE NAME IN XML"
xml_pickle.setParanoia(0)
p = xml_pickle.loads(ud_xml)
# print it so we can see the modname
print "Fullname = "+str(p)

# write it to make sure modname doesn't stick
s = xml_pickle.dumps(p)
print s

