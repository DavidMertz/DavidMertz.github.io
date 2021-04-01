#!/usr/bin/python

import sys
fh = open('picture.gif', 'r')
img = fh.read()
header = "Content-type: image/gif\n\n"
sys.stdout.write(header)
sys.stdout.write(img)

