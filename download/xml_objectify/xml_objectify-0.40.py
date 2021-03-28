""" Transform XML Documents to Python objects


Note 0:

    See http://gnosis.cx/publish/programming/xml_matters_2.txt
    for a detailed discussion of this module.

Note 1:

    The XML-SIG distribution is changed fairly frequently while
    it is in beta versions.  The changes in turn are extremely
    likely to affect the functioning of [xml_objectify].

    This version of [xml_objectify] is known to work with PyXML
    0.6.1, and will probably continue to work with later betas
    and also with the XML-SIG distribution included in Python
    2.0.  To download a current version of PyXML, go to:

      http://download.sourceforge.net/pyxml/

    Version 0.30 of [xml_objectify] was designed around PyXML
    0.5.2.  If you use an older version of PyXML, you may
    download a compatible version of [xml_pickle] at:

      http://gnosis.cx/download/xml_objectify-0.30.py

    And a known-to-be-compatible PyXML distribution at:

      http://gnosis.cx/download/py_xml_04-21-00.exe
      http://gnosis.cx/download/py_xml_04-21-00.zip

    The first URL is the Windows self-installer, the latter is
    simply an archive of those files to be unpacked under
    $PYTHONPATH/xml.

      http://gnosis.cx/download/xml_objectify.py

Note 2:

    This module is a companion to the [xml_pickle] module.
    However, the focus of each is different.  [xml_pickle] starts
    with an generic Python object, and produces a specialized XML
    document (and reads back from that custom DTD).
    [xml_objectify] starts with a generic XML document, and
    produces a somewhat specialized Python object.  Depending on
    the original and natural form of your data, one companion
    module is preferable to the other.


Usage:

    # Create a "factory object"
    xml_object = XML_Objectify('test.xml')
    # Create two different objects with recursively equal values
    py_obj1 = xml_object.make_instance()
    py_obj2 = xml_object.make_instance()

Classes:

    XML_Objectify
    _XO_

Functions:

    keep_containers(yes_no
    pyobj_from_dom(dom_node)
    safe_eval()
    pyobj_printer(py_obj)

"""

__version__ = "$Revision: 0.40 $"
__author__=["David Mertz (mertz@gnosis.cx)",]
__thanks_to__=["Grant Munsey (gmunsey@Adobe.COM)",
               "Costas Malamas (costas@malamas.com)",
               "Kapil Thangavelu (kvthan@wm.edu)"]
__copyright__="""
    This file is released to the public domain.  I (dqm) would
    appreciate it if you choose to keep derived works under terms
    that promote freedom, but obviously am giving up any rights
    to compel such.
"""

__history__="""
    0.1    Initial version

    0.11   Minor tweaks, and improvements to pyobj_printer().
           Added 'keep_containers()' function.

    0.2    Grant Munsey pointed out my gaff in allowing ad-hoc
           contained instances (subtags) to collide with Python
           names already in use.  Fixed by name-mangling ad-hoc
           classes to form "_XO_klass" corresponding with tag
           <klass>.  Attributes still use actual tag name, e.g.,
               >>> py_obj.klass
               <xml_objectify._XO_klass instance at 165a50>

    0.21   Costas Malamas pointed out that creating a template
           class does not actually *work* to create class
           behaviors.  It is necessary to get this class into the
           xml_objectify namespace.  Generally, this will involve
           an assignment similar to:
               xml_objectify._XO_Eggs = otherscope.Eggs
           A simple example can be found at:
               http://gnosis.cx/download/xo_test.py

    0.30   Costas Malamas proposed the useful improvement of
           defining __getitem__ behavior for dynamically created
           child instances.  As a result, you can use constructs
           like:
               for myegg in spam.egg:
                   print pyobj_printer(myegg)
           without needing to worry whether spam.egg is a list of
           instances or a single instance.

    0.40   Altered by Kapil Thangavelu k_vertigo@yahoo.com to work
           with the latest version of PyXML 0.61.  Mainly syntax
           changes to reflect PyXML's move to 4DOM.

"""

from types import *
#from xml.dom.utils import FileReader
from xml.dom.ext.reader.Sax import FromXmlStream, FromXmlFile

from xml.dom.ext import Printer
from StringIO import StringIO
import copy, string

#-- Node types
# node types are now class constants defined in Node. we use the class
# itself directly to compare values.
from xml.dom.Node import Node

#-- Global option to save every container tag content
KEEP_CONTAINERS = 0
def keep_containers(val):
    global KEEP_CONTAINERS
    KEEP_CONTAINERS = val

#-- Base class for objectified XML nodes
class _XO_:
    def __getitem__(self, key):
        if not key:
            return self
        else:
            raise IndexError

#-- Class interface to module functionality
class XML_Objectify:
    """Factory object class for 'objectify XML document'"""
    def __init__(self, file=None):
        if type(file) == StringType:
            self._dom = FromXmlFile(file)
        elif type(file) == FileType:
            self._dom = FromXmlStream(file)
        else:
            raise ValueError, \
                  "XML_Objectify must be initialized with filename or file handle"

        self._processing_instruction = {}

        for child in self._dom.childNodes:
            if child.nodeType == Node.PROCESSING_INSTRUCTION_NODE:
                self._processing_instruction[child.nodeName] = child.nodeValue
            elif child.nodeType == Node.ELEMENT_NODE:
                self._root = child.nodeName
        self._PyObject = pyobj_from_dom(self._dom)

    def make_instance(self):
        return copy.deepcopy(getattr(self._PyObject, self._root))


#-- Helper functions
def pyobj_from_dom(dom_node):
    """Converts a DOM tree to a "native" Python object"""

    # does the tag-named class exist, or should we create it?
    klass = '_XO_'+py_name(dom_node.nodeName)

    try:
        safe_eval(klass)
    except NameError:
        exec ('class %s(_XO_): pass' % klass)
    # create an instance of the tag-named class
    py_obj = eval('%s()' % klass)

    # attach any tag attributes as instance attributes
    attr_dict = dom_node.attributes
    if attr_dict is None:
        attr_dict = {}
    for key, val in attr_dict.items():
        setattr(py_obj, py_name(key), val.value)

    # for nodes with character markup, might want the literal XML

    xml_stream = StringIO()
    printer = Printer.PrintVisitor(xml_stream, 'UTF-8')

    intro_PCDATA, subtag, exit_PCDATA = (0, 0, 0)

    # now look at the actual tag contents (subtags and PCDATA)
    for node in dom_node.childNodes:
        node_name = py_name(node.nodeName)
        printer.visit(node)

        # PCDATA is a kind of node, but not a new subtag
        if node.nodeName == '#text':
            if hasattr(py_obj, 'PCDATA'):
                py_obj.PCDATA = py_obj.PCDATA + node.nodeValue
            elif string.strip(node.nodeValue):    # only use "real" node contents
                py_obj.PCDATA = node.nodeValue    # (not bare whitespace)
                if not subtag: intro_PCDATA = 1
                else: exit_PCDATA = 1

        # does a py_obj attribute corresponding to the subtag already exist?
        elif hasattr(py_obj, node_name):
            # convert a single child object into a list of children
            if type(getattr(py_obj, node_name)) is not ListType:
                setattr(py_obj, node_name, [getattr(py_obj, node_name)])
            # add the new subtag to the list of children
            getattr(py_obj, node_name).append(pyobj_from_dom(node))

        # start out by creating a child object as attribute value
        else:
            setattr(py_obj, node_name, pyobj_from_dom(node))
            subtag = 1

    # if dom_node appears to contain character markup, save literal XML
    if subtag and (intro_PCDATA or exit_PCDATA):
        py_obj._XML = xml_stream.get_value()
    elif KEEP_CONTAINERS:    # ...and if option is specified explicitly
        py_obj._XML = xml_stream.get_value()

    return py_obj

def py_name(name):
    name = string.replace(name, '#', '_')
    name = string.replace(name, ':', '_')
    name = string.replace(name, '-', '_')
    return name

def safe_eval(s):
    if 0:   # Condition for malicious string in eval() block
        raise "SecurityError", \
              "Malicious string '%s' should not be eval()'d" % s
    else:
        return eval(s)


#-- Self-test utility functions
def pyobj_printer(py_obj, level=0):
    """Return a "deep" string description of a Python object"""
    if level==0: descript = '-----* '+py_obj.__class__.__name__+' *-----\n'
    else: descript = ''
    if hasattr(py_obj, '_XML'):     # present the literal XML of object
        prettified_XML = string.join(string.split(py_obj._XML))[:50]
        descript = (' '*level)+'CONTENT='+prettified_XML+'...\n'
    else:                           # present the object hierarchy view
        for membname in dir(py_obj):
            member = getattr(py_obj,membname)
            if type(member) == InstanceType:
                descript = descript+'\n'+(' '*level)+'{'+membname+'}\n'
                descript = descript + pyobj_printer(member, level+3)
            elif type(member) == ListType:
                for i in range(len(member)):
                    descript = descript+'\n'+(' '*level)+ \
                               '['+membname+'] #'+str(i+1)
                    descript = descript+(' '*level)+'\n'+ \
                               pyobj_printer(member[i],level+3)
            else:
                descript = descript+(' '*level)+membname+'='
                memval = string.join(string.split(str(member)))
                if len(memval) > 50:
                    descript = descript+memval[:50]+'...\n'
                else:
                    descript = descript+memval + '\n'
    return descript


#-- Module self-test
if __name__ == '__main__':
    import sys
    if len(sys.argv) > 1:
        for filename in sys.argv[1:]:
            xml_obj = XML_Objectify(filename)
            py_obj = xml_obj.make_instance()
            print pyobj_printer(py_obj)
    else:
        print "Please specify one or more XML files to Objectify."

