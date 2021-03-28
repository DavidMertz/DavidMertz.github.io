
#
# shortcut script to install for all python versions I have installed
#
# Two ways to run:
#
#   1. If sitting in toplevel dir (above gnosis/), will build
#      and install Gnosis from gnosis/ for all python versions,
#      first removing any existing Gnosis installation.
#
#   2. If sitting in dist/, unpack the built sdist and install
#      from it for all Python versions, first removing any
#      existing Gnosis installation.
#

import os, sys, re
from glob import glob

def run(cmd):
    print "%s" % cmd
    if os.system(cmd) != 0:
        print "ERROR"
        sys.exit(1)

for py in ['python2.0','python2.1','python2.2','python2.3']:
    if os.name == 'posix':
        run('rm -rf /usr/lib/%s/site-packages/gnosis' % py)

    l = glob('Gnosis_Utils-*.tar.gz')
    if len(l) == 1:
        m = re.match('(Gnosis_Utils-[0-9\.]+)\.tar\.gz',l[0])
        if not m:
            raise "Yikes - wha happen?"

        run('tar zxvf Gnosis_Utils*.tar.gz')
        os.chdir(m.group(1))

        run('%s setup_gnosis.py build' % py)
        run('%s setup_gnosis.py install' % py)

        os.chdir('..')
        run('rm -rf %s' % m.group(1))       
    else:
        run('rm -rf build')
        run('%s setup_gnosis.py build' % py)
        run('%s setup_gnosis.py install' % py)
    
