#!/usr/bin/python

import os
from sys import stdout
from time import time,ctime

now = ctime(time())
addr = os.environ.get("REMOTE_ADDR","Unknown IP Address")
agent = os.environ.get("HTTP_USER_AGENT","No Known Browser")
try: ref = os.environment["HTTP_REFERER"]
except: ref = ""

fh = open('visitor.log','a')
fh.write('%s\t%s\t%s\t%s\n' % (now, addr, agent, ref))
fh.close()

stdout.write("Content-type: image/gif\n\n")
stdout.write('GIF89a\001\000\001\000\370\000\000\000\000\000')
stdout.write('\000\000\000!\371\004\001\000\000\000\000,\000')
stdout.write('\000\000\000\001\000\001\000\000\002\002D\001\000;')
