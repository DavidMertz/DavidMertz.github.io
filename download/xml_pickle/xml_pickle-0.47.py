"""Store Python objects to (pickle-like) XML Documents

Note 0:

    See http://gnosis.cx/publish/programming/xml_matters_1.txt
    for a detailed discussion of this module.

    Some enhancements have been contributed by various users,
    please see the __history__ for details.  Some enhancements
    may go beyond what is discussed in the referenced article.

Note 1:

    The XML-SIG distribution is changed fairly frequently while
    it is in beta versions.  The changes in turn are extremely
    likely to affect the functioning of [xml_pickle].

    This version of [xml_pickle] is known to work with PyXML
    Python 2.0 and 2.1b1, and will probably continue to work with
    later betas.  Hopefully, it will also work with PyXML 0.6.1
    and above. To download a current version of PyXML, go to:

      http://download.sourceforge.net/pyxml/

    Version 0.22 of [xml_pickle] was designed around PyXML 0.5.2.
    If you use an older version of PyXML, you may download a
    compatible version of [xml_pickle] at:

      http://gnosis.cx/download/xml_pickle-0.22.py

    And a known-to-be-compatible PyXML distribution at:

      http://gnosis.cx/download/py_xml_04-21-00.exe
      http://gnosis.cx/download/py_xml_04-21-00.zip

    The first URL is the Windows self-installer, the latter is
    simply an archive of those files to be unpacked under
    $PYTHONPATH/xml.

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

__version__ = "$Revision: 0.47 $"
__author__=["David Mertz (mertz@gnosis.cx)",]
__thanks_to__=["Grant Munsey (gmunsey@Adobe.COM)",
               "Keith J. Farmer (deoradh@yahoo.com)",
               "Anthony Baxter (anthony@interlink.com.au)",
               "Joshua Macy (j_amused@yahoo.com)",
               "Curtis Jensen (cjensen@bioeng.ucsd.edu)",
               "Joe Kraska (jkraska@bbn.com)",]
__copyright__="""
    This file is released to the public domain.  I (dqm) would
    appreciate it if you choose to keep derived works under terms
    that promote freedom, but obviously am giving up any rights
    to compel such.
"""

__history__="""
    0.1    Initial version

    0.22   Compatible with PyXML 0.52

    0.30   Compatible with PyXML 0.61+

    0.40   Joshua Macy added several worthwhile things.  This
           version is compatibility with Python 2.1 (and 2.0),
           assuming nothing changes between the beta and release.

           More importantly, Joshua added checks for cyclical
           references and for multiple bindings of identical
           objects.  Previously, xml_pickle effectively forced a
           deep copy; for example:

             obj.a = aDict
             obj.b = aDict
             obj.b is obj.a   # True
             ... pickle then restore ...
             obj.a is obj.b   # False

           With version 0.40, object identity is preserved across
           pickling.

    0.45   Finally added Curtis Jensen's enhancements to use NumPy
           array type.

    0.46   Joe Kraska pointed out referential inconsistencies in
           cyclical references, and provided changes (OK'd by
           Joshua Macy, who did the referential code to start
           with).

    0.47   Improvement of the '_tag_completer()' flow control
           in case of referential objects (consistent fall-
           through to single 'return' statement.

"""

from types import *
from xml.dom import minidom
import cStringIO

# Get appropriate array type.
try:
  from Numeric import *
  array_type = 'NumPy_array'
except ImportError:
  from array import *
  array_type = 'array'

XMLPicklingError = "xml_pickle.XMLPicklingError"
XMLUnpicklingError = "xml_pickle.XMLUnpicklingError"

# Maintain list of object identities for multiple and cyclical references
visited = {}

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
        global visited
        visited = {}
        return thing_from_dom(minidom.parseString(fh.read()))

    def dumps(self):
        """Create the XML representation as a string"""
        # Store the ref id to the pickling object
        global visited
        visited = {}
        id_ = id(self.py_obj)
        visited[id_] = self.py_obj
        # Generate the XML string
        xml_str = '<?xml version="1.0"?>\n' +\
                  '<!DOCTYPE PyObject SYSTEM "PyObjects.dtd">\n'
        xml_str = xml_str+'<PyObject class="%s" id="%s">\n' \
                           % (_klass(self.py_obj),id_)
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
        if node.nodeName == "PyObject":
            # Add all the subnodes to PyObject container
            container = thing_from_dom(node, obj_from_node(node))
            try:
                id = node.attributes[('', 'id')].value
                visited[id] = container
            except KeyError:
                pass
        elif node.nodeName == 'attr':
            try:
                node_type = node.attributes[('','type')].value
            except:
                print "node", node.attributes, repr(node.attributes)
                print node.attributes.keys()
                raise    # WHAT?!
            node_name = node.attributes[('', 'name')].value
            if node_type == 'None':
                setattr(container, node_name, None)
            elif node_type == 'numeric':
                node_val = safe_eval(node.attributes[('','value')].value)
                setattr(container, node_name, node_val)
            elif node_type == 'string':
                node_val = node.attributes[('','value')].value
                node_val = unsafe_string(node_val)
                setattr(container, node_name, node_val)
            elif node_type == 'list':
                subcontainer = thing_from_dom(node, [])
                setattr(container, node_name, subcontainer)
                try:
                    id = node.attributes[('', 'id')].value
                    visited[id] = subcontainer
                except KeyError:
                    pass
            elif node_type == 'tuple':
                subcontainer = thing_from_dom(node, []) # use list then convert
                setattr(container, node_name, tuple(subcontainer))
                try:
                    id = node.attributes[('', 'id')].value
                    visited[id] = subcontainer
                except KeyError:
                    pass
            elif node_type == array_type:
                subcontainer = thing_from_dom(node, [])
                if (array_type == 'NumPy_array'):
                    setattr(container, node_name, array(subcontainer))
                else:   # need to figure out array member types to convert
                    int_val = 1
                    for item in subcontainer:
                        if type(item) == type(1.0):
                            int_val = 0
                    if int_val:
                        setattr(container, node_name, array('b',subcontainer))
                    else:
                        setattr(container, node_name, array('f',subcontainer))
            elif node_type == 'dict':
                subcontainer = thing_from_dom(node, {})
                setattr(container, node_name, subcontainer)
                try:
                    id = node.attributes[('', 'id')].value
                    visited[id] = subcontainer
                except KeyError:
                    pass
            elif node_type == 'PyObject':
                subcontainer = thing_from_dom(node, obj_from_node(node))
                setattr(container, node_name, subcontainer)
                try:
                    id = node.attributes[('', 'id')].value
                    visited[id] = subcontainer
                except KeyError:
                    pass
            elif node_type == 'ref':
                ref_id = node.attributes[('', 'refid')].value
                setattr(container, node_name, visited[ref_id])

        elif node.nodeName in ['item', 'key', 'val']:
            # -- About key/val nodes --
            # There *should not* be mutable types as keys, but to cover
            # all cases, elif's are defined for mutable types. Furthermore,
            # there should only ever be *one* item in any key/val list,
            # but we again rely on other validation of the XML happening.
            node_type = str(node.attributes[('','type')].value)
            if  node_type == 'numeric':
                node_val = safe_eval(node.attributes[('','value')].value)
                container.append(node_val)
            elif node_type == 'string':
                node_val = node.attributes[('','value')].value
                node_val = unsafe_string(node_val)
                container.append(node_val)
            elif node_type in ('list',array_type):
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

        elif node.nodeName == 'entry':
            keyval = thing_from_dom(node, [])
            key, val = keyval[0], keyval[1]
            container[key] = val

        else:
            raise XMLUnpicklingError, \
                  "element %s is not in PyObjects.dtd" % node.nodeName

    return container

def obj_from_node(node):
    # Get classname of object (with fallback to 'PyObject')
    try:
        if node.attributes:
            klass = node.attributes[('','class')].value
        else:
            klass = 'PyObject'
    except KeyError: klass = 'PyObject'

    # does the class exist, or should we create it?
    try: safe_eval(klass)
    except NameError:
         exec ('class %s: pass' % klass)
    return eval('%s()' % klass)

def subnodes(node):
    return filter(lambda n: n.nodeName<>'#text', node.childNodes)

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
    elif type(thing) in [UnicodeType]:
        thing = str(thing)
        start_tag = start_tag + 'type="string" value="%s"/>\n>' % thing
        close_tag = ''
    elif type(thing) in [TupleType]:
        if visited.get(id(thing)):
            start_tag = start_tag + 'type="ref" refid="%s" />\n' % id(thing)
            close_tag = ''
        else:
            visited[id(thing)] = 1
            start_tag = start_tag+'type="tuple" id="%s">\n' % id(thing)
            for item in thing:
                tag_body = tag_body+_item_tag(item, level+1)
    elif type(thing) in [ListType]:
        if visited.get(id(thing)):
            start_tag = start_tag + 'type="ref" refid="%s" />\n' % id(thing)
            close_tag = ''
        else:
            visited[id(thing)] = 1
            start_tag = start_tag+'type="list" id="%s">\n' % id(thing)
            for item in thing:
                tag_body = tag_body+_item_tag(item, level+1)
    elif type(thing) in [ArrayType]:
        start_tag = start_tag+'type=\"%s\">\n' % array_type
        for item in thing:
            tag_body = tag_body+_item_tag(item, level+1)
    elif type(thing) in [DictType]:
        if visited.get(id(thing)):
            start_tag = start_tag + 'type="ref" refid="%s" />\n' % id(thing)
            close_tag = ''
        else:
            visited[id(thing)] = 1
            start_tag = start_tag+'type="dict" id="%s">\n' % id(thing)
            for key, val in thing.items():
                tag_body = tag_body+_entry_tag(key, val, level+1)
    elif type(thing) == CodeType:
        # code objects are not picklable
        start_tag = start_tag+'type="None" />\n'
        close_tag = ''
    elif type(thing) == FunctionType:
        # function objects may be not be picklable, I'm not sure.
        # Standard pickle will pickle functions defined at the top
        # level, but only their names, not their implementations
        start_tag = start_tag+'type="function" />\n' # maybe should be None?
        close_tag = ''
    elif type(thing) in [InstanceType]:
        if visited.get(id(thing)):
            start_tag = start_tag + 'type="ref" refid="%s" />\n' % id(thing)
            close_tag = ''
        else:
            visited[id(thing)] = 1
            start_tag = start_tag + 'type="PyObject" class="%s" id="%s">\n' \
                                              % (_klass(thing), id(thing))
            for name in dir(thing):
                tag_body = tag_body+_attr_tag(name, getattr(thing, name), level+1)
    elif '%s' % type(thing) == "<type 'SRE_Pattern'>":
        # SRE_Pattern objects are extension objects, so not
        # picklable.  A possible enhancement is to pickle off
        # the re pattern, and recompile it upon unpickling
        start_tag = start_tag + 'type="SRE" />\n'
    else:
        raise XMLPicklingError, "non-handled type %s" % type(thing)

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

#-- Self test
if __name__ == "__main__":
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

