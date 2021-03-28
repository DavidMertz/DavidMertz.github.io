class _XO_Eggs:
    def __init__(self):
        self.this = 'that'
    def hello(self):
        print "Hello world"

xml_str ="""<?xml version="1.0"?>
<!DOCTYPE Spam SYSTEM "spam.dtd" >
<Spam>
  <Eggs>Some text about eggs.</Eggs>
  <MoreSpam>Ode to Spam</MoreSpam>
</Spam>"""
xml_file = open('test.xml', 'w')
xml_file.write(xml_str)
xml_file.close()

from xml_objectify import *

#-- Create an instance, but don't manage to find our _XO_Eggs class!
xml_object = XML_Objectify('test.xml')
py_obj = xml_object.make_instance()
print pyobj_printer(py_obj)
try:    py_obj.Eggs.hello()
except: print "Eggs don't say hello"

#-- OK, have to get our _XO_Eggs class into the xml_objectify namespace!
import xml_objectify
xml_objectify._XO_Eggs = _XO_Eggs

xml_object = XML_Objectify('test.xml')
py_obj = xml_object.make_instance()
print pyobj_printer(py_obj)
try:    py_obj.Eggs.hello()
except: print "Eggs don't say hello"

