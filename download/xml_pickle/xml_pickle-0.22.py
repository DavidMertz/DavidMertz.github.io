"""Store Python objects to (pickle-like) XML Documents

Note:

    The XML-SIG distribution is changed fairly frequently while
    it is in beta versions.  The changes in turn are extremely
    likely to affect the functioning of [xml_pickle].  Therefore,
    an XML-SIG version known to be compatible with [xml_pickle]
    may be found at:

      http://gnosis.cx/download/py_xml_04-21-00.exe
      http://gnosis.cx/download/py_xml_04-21-00.zip

    The first URL is the Windows self-installer, the latter is
    simply an archive of those files to be unpacked under
    $PYTHONPATH/xml.

    Whenever the XML-SIG distribution reaches a release version
    and/or when the XML package is a part of an official Python
    release, the current [xml_pickle] should be updated to work
    with the official release.  The most current [xml_pickle]
    should always be available at:

      http://gnosis.cx/download/xml_pickle.py

Usage:

    # By inheritence
    from xml_pickle import XML_Pickler
    class MyClass(XML_Pickler):
        # create some behavior and attributes for MyClass...
    o1 = MyClass()
    xml_str = o.dumps()
    o2 = MyClass()
    o2.loads(xml_str)

    # With inline instantiation
    from xml_pickle import XML_Pickler
    o1 = DataClass()
    # ...assign attribute values to o1...
    xml_str = XML_Pickler(o1).dumps()
    o2 = XML_Pickler().loads(xml_str)

Classes:

    PyObject
    XML_Pickler

Functions:

    thing_from_dom(dom_node, container)
    obj_from_node(node)
    subnodes(node)
    _attr_tag(...)
    _item_tag(...)
    _entry_tag(...)
    _tag_completer(...)
    _klass(...)
    safe_eval(s)
    safe_string(s)
    unsafe_string(s)

"""

__version__ = "$Revision: 0.22 $"
__author__=["David Mertz (mertz@gnosis.cx)",]
__thanks_to__=["Grant Munsey (gmunsey@Adobe.COM)",
               "Keith J. Farmer (deoradh@yahoo.com)"]
__copyright__="""
    This file is released to the public domain.  I (dqm) would
    appreciate it if you choose to keep derived works under terms
    that promote freedom, but obviously am giving up any rights
    to compel such.
"""

from types import *
from xml.dom.utils import FileReader
import cStringIO

XMLPicklingError = "xml_pickle.XMLPicklingError"
XMLUnpicklingError = "xml_pickle.XMLUnpicklingError"

class PyObject:
    """Placeholder template class"""
    def __init__(self, __fakename__=None):
        if __fakename__: self.__fakename__ = __fakename__

class XML_Pickler:
    """Framework for 'pickle to XML'"""
    def __init__(self, py_obj=None):
        if py_obj is not None:
            if type(py_obj)<>InstanceType:
                raise ValueError, \
                      "XML_Pickler must be initialized with Instance (or None)"
            self.py_obj = py_obj
        else:
            self.py_obj = PyObject(self.__class__.__name__)

    def __setattr__(self, name, value):
        if name == 'py_obj':
            self.__dict__[name] = value
        else:
            setattr(self.py_obj, name, value)

    def __getattr__(self, name):
        return getattr(self.py_obj, name)

    def __delattr__(self, name):
        del self.py_obj.__dict__[name]

    def dump(self, fh):
        # admittedly, our approach requires creating whole output XML in
        # memory first, which could be large for complex object.  Maybe
        # we'll make this more efficient later.
        fh.write(self.dumps())

    def load(self, fh):
        return thing_from_dom(FileReader().readXml(fh))

    def dumps(self):
        xml_str = '<?xml version="1.0"?>\n' +\
                  '<!DOCTYPE PyObject SYSTEM "PyObjects.dtd">\n'
        xml_str = xml_str+'<PyObject class="%s">\n' % _klass(self.py_obj)
        for name in dir(self.py_obj):
            xml_str = xml_str+_attr_tag(name, getattr(self, name))
        xml_str = xml_str+'</PyObject>'
        return xml_str

    def loads(self, xml_str):
        fh = cStringIO.StringIO(xml_str)
        obj = self.load(fh)
        fh.close()
        return obj


#-- support functions
def thing_from_dom(dom_node, container=None):
    """Converts an [xml_pickle] DOM tree to a "native" Python object"""
    for node in subnodes(dom_node):
        if node.name == "PyObject":
            # Add all the subnodes to PyObject container
            container = thing_from_dom(node, obj_from_node(node))

        elif node.name == 'attr':
            node_type = node.get_attributes()['type'].value
            node_name = node.get_attributes()['name'].value
            if node_type == 'None':
                setattr(container, node_name, None)
            elif node_type == 'numeric':
                node_val = safe_eval(node.get_attributes()['value'].value)
                setattr(container, node_name, node_val)
            elif node_type == 'string':
                node_val = node.get_attributes()['value'].value
                node_val = unsafe_string(node_val)
                setattr(container, node_name, node_val)
            elif node_type == 'list':
                subcontainer = thing_from_dom(node, [])
                setattr(container, node_name, subcontainer)
            elif node_type == 'tuple':
                subcontainer = thing_from_dom(node, []) # use list then convert
                setattr(container, node_name, tuple(subcontainer))
            elif node_type == 'dict':
                subcontainer = thing_from_dom(node, {})
                setattr(container, node_name, subcontainer)
            elif node_type == 'PyObject':
                subcontainer = thing_from_dom(node, obj_from_node(node))
                setattr(container, node_name, subcontainer)

        elif node.name in ['item', 'key', 'val']:
            # -- Odd behavior warning --
            # The 'node_type' expression has an odd tendency to be a
            # one-element tuple rather than a string.  Doing the str()
            # fixes things, but I'm not sure why!
            # -- About key/val nodes --
            # There *should not* be mutable types as keys, but to cover
            # all cases, elif's are defined for mutable types. Furthermore,
            # there should only ever be *one* item in any key/val list,
            # but we again rely on other validation of the XML happening.
            node_type = str(node.get_attributes()['type'].value)
            if  node_type == 'numeric':
                node_val = safe_eval(node.get_attributes()['value'].value)
                container.append(node_val)
            elif node_type == 'string':
                node_val = node.get_attributes()['value'].value
                node_val = unsafe_string(node_val)
                container.append(node_val)
            elif node_type == 'list':
                subcontainer = thing_from_dom(node, [])
                container.append(subcontainer)
            elif node_type == 'tuple':
                subcontainer = thing_from_dom(node, []) # use list then convert
                container.append(tuple(subcontainer))
            elif node_type == 'dict':
                subcontainer = thing_from_dom(node, {})
                container.append(subcontainer)
            elif node_type == 'PyObject':
                subcontainer = thing_from_dom(node, obj_from_node(node))
                container.append(subcontainer)

        elif node.name == 'entry':
            keyval = thing_from_dom(node, [])
            key, val = keyval[0], keyval[1]
            container[key] = val

        else:
            raise XMLUnpicklingError, \
                  "element %s is not in PyObjects.dtd" % node.name

    return container

def obj_from_node(node):
    # Get classname of object (with fallback to 'PyObject')
    try: klass = node.get_attributes()['class'].value
    except KeyError: klass = 'PyObject'

    # does the class exist, or should we create it?
    try: safe_eval(klass)
    except NameError:
         exec ('class %s: pass' % klass)
    return eval('%s()' % klass)

def subnodes(node):
    return filter(lambda n: n.name<>'#text', node.get_childNodes())

def _attr_tag(name, thing, level=0):
    start_tag = '  '*level+('<attr name="%s" ' % name)
    close_tag ='  '*level+'</attr>\n'
    if name == '__fakename__': return ''
    else:
        return _tag_completer(start_tag, thing, close_tag, level)

def _item_tag(thing, level=0):
    start_tag = '  '*level+'<item '
    close_tag ='  '*level+'</item>\n'
    return _tag_completer(start_tag, thing, close_tag, level)

def _entry_tag(key, val, level=0):
    start_tag = '  '*level+'<entry>\n'
    close_tag = '  '*level+'</entry>\n'
    start_key = '  '*level+'  <key '
    close_key = '  '*level+'  </key>\n'
    key_block = _tag_completer(start_key, key, close_key, level+1)
    start_val = '  '*level+'  <val '
    close_val = '  '*level+'  </val>\n'
    val_block = _tag_completer(start_val, val, close_val, level+1)
    return (start_tag + key_block + val_block + close_tag)

def _tag_completer(start_tag, thing, close_tag, level=0):
    tag_body = ''
    if type(thing) == NoneType:
        start_tag = start_tag+'type="None" />\n'
        close_tag = ''
    elif type(thing) in [IntType, LongType, FloatType, ComplexType]:
        start_tag = start_tag+'type="numeric" value="%s" />\n' % `thing`
        close_tag = ''
    elif type(thing) in [StringType]:
        thing = safe_string(thing)
        start_tag = start_tag+'type="string" value="%s" />\n' % thing
        close_tag = ''
    elif type(thing) in [TupleType]:
        start_tag = start_tag+'type="tuple">\n'
        for item in thing:
            tag_body = tag_body+_item_tag(item, level+1)
    elif type(thing) in [ListType]:
        start_tag = start_tag+'type="list">\n'
        for item in thing:
            tag_body = tag_body+_item_tag(item, level+1)
    elif type(thing) in [DictType]:
        start_tag = start_tag+'type="dict">\n'
        for key, val in thing.items():
            tag_body = tag_body+_entry_tag(key, val, level+1)
    elif type(thing) in [InstanceType]:
        start_tag = start_tag+'type="PyObject" class="%s">\n' % _klass(thing)
        for name in dir(thing):
            tag_body = tag_body+_attr_tag(name, getattr(thing, name), level+1)
    else:
        raise XMLPicklingError, "non-handled type %s." % type(thing)
    return start_tag+tag_body+close_tag

def _klass(thing):
    if type(thing)<>InstanceType:
        raise ValueError, \
              "non-Instance type %s passed to _klass()" % type(thing)
    if hasattr(thing, '__fakename__'): return thing.__fakename__
    else: return thing.__class__.__name__

def safe_eval(s):
    if 0:   # Condition for malicious string in eval() block
        raise "SecurityError", \
              "Malicious string '%s' should not be eval()'d" % s
    else:
        return eval(s)

def safe_string(s):
    import string, re
    # markup XML entities
    s = string.replace(s, '&', '&amp;')
    s = string.replace(s, '<', '&lt;')
    s = string.replace(s, '>', '&gt;')
    s = string.replace(s, '"', '&quot;')
    s = string.replace(s, "'", '&apos;')
    # for others, use Python style escapes
    s = repr(s)
    return s[1:-1]  # without the extra single-quotes

def unsafe_string(s):
    import string, re
    # for Python escapes, exec the string
    # (niggle w/ literalizing apostrophe)
    s = string.replace(s, "'", r"\047")
    exec "s='"+s+"'"
    # XML entities (DOM does it for us)
    return s

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
         <attr name="swindler" type="string" value="Ed's Auto" />
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

#-- Self test
if __name__ == "__main__":
    class MyClass: pass
    o = XML_Pickler()
    o.num = 37
    o.str = "Hello World \n Special Chars: \t \000 < > & ' \207"
    o.lst = [1, 3.5, 2, 4+7j]
    o2 = MyClass()
    o2.tup = ("x", "y", "z")
    o2.num = 2+2j
    o2.dct = { "this": "that", "spam": "eggs", 3.14: "about PI" }
    o.obj = o2
    print '------* Print python-defined pickled object *-----'
    print o.dumps()

    print '-----* Load a test xml_pickle object, and print it *-----'
    u = o.loads(test_xml)
    print XML_Pickler(u).dumps()
