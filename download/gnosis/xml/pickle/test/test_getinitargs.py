import pickle, gnosis.xml.pickle
import funcs

funcs.set_parser()
gnosis.xml.pickle.setParanoia(0)

print "DESIRED BEHAVIOR:"
print "  X.__init__() should be called when instances are created,"
print "  and also when either a plain or xml pickle is restored."

class X:
    __safe_for_unpickling__ = 1
    def __init__(self):
        print "In __init__()"
    def __getinitargs__(self):
        return ()

print "\nCREATE X INSTANCE:"
x = X()

print "\nPICKLE DUMP:"
p = pickle.dumps(x)
print `p`
print "\nPICKLE LOAD:"
x2 = pickle.loads(p)

print "\nGNOSIS.XML.PICKLE DUMP:"
px = gnosis.xml.pickle.dumps(x)
print px,
print "\nGNOSIS.XML.PICKLE LOAD:"
x3 = gnosis.xml.pickle.loads(px)
