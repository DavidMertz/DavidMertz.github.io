import gzip, cStringIO
import gnosis.xml.pickle as xml_pickle

# --- Make an object to play with ---
class C: pass
o = C()
o.lst, o.dct = [1,2], {'spam':'eggs'}
s = xml_pickle.gzdumps(o)

print '------------- Progressively compressed pickle -------------'
print `s`
print '------------- Uncompressed gzstream -----------------------'
print xml_pickle.ungz_string(s)
print '------------- Restore gzstream to object ------------------'
o2 = xml_pickle.gzloads(s)
print xml_pickle.dumps(o2)


