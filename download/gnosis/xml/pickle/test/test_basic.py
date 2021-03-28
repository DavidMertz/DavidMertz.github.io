#-- Hand generated test object
test_xml = """<?xml version="1.0"?>
<!DOCTYPE PyObject SYSTEM "PyObjects.dtd">

<PyObject class="Automobile">
   <attr name="doors" type="numeric" value="4" />
   <attr name="make" type="string" value="Honda" />
   <attr name="tow_hitch" type="None" />
   <attr name="prev_owners" type="tuple">
      <item type="string" value="Jane Smith" />
      <item type="tuple">
         <item type="string" value="John Doe" />
         <item type="string" value="Betty Doe" />
      </item>
      <item type="string" value="Charles Ng" />
   </attr>
   <attr name="repairs" type="list">
      <item type="string" value="June 1, 1999:  Fixed radiator" />
      <item type="PyObject" class="Swindle">
         <attr name="date" type="string" value="July 1, 1999" />
         <attr name="swindler" type="string" value="Ed\'s Auto" />
         <attr name="purport" type="string" value="Fix A/C" />
      </item>
   </attr>
   <attr name="options" type="dict">
      <entry>
         <key type="string" value="Cup Holders" />
         <val type="numeric" value="4" />
      </entry>
      <entry>
         <key type="string" value="Custom Wheels" />
         <val type="string" value="Chrome Spoked" />
      </entry>
   </attr>
   <attr name="engine" type="PyObject" class="Engine">
      <attr name="cylinders" type="numeric" value="4" />
      <attr name="manufacturer" type="string" value="Ford" />
   </attr>
</PyObject>"""

if __name__=='__main__':
    from gnosis.xml.pickle import XML_Pickler
    import gnosis.xml.pickle as xml_pickle  
    from gnosis.xml.pickle.util import add_class_to_store
    import funcs

    funcs.set_parser()         
    
    class MyClass: pass
    o = XML_Pickler()
    o.num = 37
    o.str = "Hello World \n Special Chars: \t \000 < > & ' \207"
    o.lst = [1, 3.5, 2, 4+7j]
    o.lst2 = o.lst
    o2 = MyClass()
    o2.tup = ("x", "y", "z")
    o2.tup2 = o2.tup
    o2.num = 2+2j
    o2.dct = { "this": "that", "spam": "eggs", 3.14: "about PI" }
    o2.dct2 = o2.dct
    o.obj = o2
    print '------* Print python-defined pickled object *-----'
    s = o.dumps()
    print s
    print '------* Load it and print it again *-----'
    print '------ should look approximately the same ---'
    t = o.loads(s)
    print t.dumps()
    print '-----* Load a test xml_pickle object, and print it *-----'
    u = o.loads(test_xml)
    print XML_Pickler(u).dumps()

