from gnosis.xml.objectify import make_instance
from gnosis.xml.objectify.utils import *
import sys

xml = '''<foo>
  <bar>this</bar>
  <bar>that</bar>
  <bar>other</bar>
</foo>'''

o = make_instance(xml)

for node in XPATH(o,'bar'):
    print node


