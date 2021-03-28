import gnosis.xml.pickle as xml_pickle

class Test: pass
o1 = Test()
o1.s = "o1"

o2 = Test()
o2.s = "o2"

o1.obj1 = o2
o1.obj2 = o2
o2.obj3 = o1
o2.obj4 = o1

xml = xml_pickle.XML_Pickler(o1).dumps()
print xml

