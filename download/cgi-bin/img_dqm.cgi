#!/usr/bin/python

import sys, time, glob, string

pix = glob.glob('../general_images/dqm?.jpg')
which = int(time.time()) % len(pix)
fh = open(pix[which], 'r')
img = fh.read()
header = "Content-type: image/jpeg\n\n"
sys.stdout.write(header)
sys.stdout.write(img)



