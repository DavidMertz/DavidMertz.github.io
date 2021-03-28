# Installing Gnosis_Utils:
#
#     python setup_gnosis.py build
#     python setup_gnosis.py install
#

from distutils.core import setup
import os, sys, glob

# sanity check for botched Python installations
# (probably means that pyexpat wasn't built)
def is_DOM_okay():
    s = '<?xml version="1.0"?><P></P>'
    import StringIO
    try:
        from xml.dom import minidom
        minidom.parse(StringIO.StringIO(s))
        return 1
    except:
        return 0

if not os.path.exists('MANIFEST'):
    # should only happen in the dev environment if you do a 'make clean'
    # without remaking the sdist
    print "AAARGH! Missing MANIFEST - you probably need to do 'make dist' first"
    sys.exit(1)

# ensure that an entire path exists
# os.makedirs doesn't seem to work as I expected ... :-(
def makepath(path):
    # path is from MANIFEST, so we know it'll have forward slashes
    # (see distutils docs)
    parts = path.split('/')
    partial = ''
    for part in parts:
        partial = os.path.join(partial,part)
        try: os.mkdir(partial)
        except: pass

# try running setup(), returning 1 on success, 0 on failure
def do_setup():
    try:
        kwargs = {
            # mappings to PKG-INFO:
            #   name             -> Name
            #   version          -> Version
            #   description      -> Summary
            #   url              -> Home-page
            #   author           -> Author
            #   author_email     -> Author-email
            #   licence (sp!)    -> License
            #   long_description -> Description
            #   platforms        -> Platform (multiple lines if needed)

            'name' : "Gnosis_Utils",
            'version': "1.0.7",
            'description': "Modules and Utilities for XML Documents and Other Miscellany",
            'long_description': "Include modules: xml.pickle, xml.objectify, xml.indexer, xml.validity, and friends.",
            'author': "Gnosis Software",
            'author_email': "mertz@gnosis.cx",
            'url': "http://gnosis.cx/download/",
            'packages': ["gnosis",
                         "gnosis.anon",
                         "gnosis.magic",
                         "gnosis.util",
                         "gnosis.util.convert",
                         "gnosis.xml",
                         "gnosis.xml.objectify",
                         "gnosis.xml.objectify.doc",
                         "gnosis.xml.objectify.test",
                         "gnosis.xml.pickle",
                         "gnosis.xml.pickle.ext",
                         "gnosis.xml.pickle.util",
                         "gnosis.xml.pickle.doc",
                         "gnosis.xml.pickle.test",
                         "gnosis.xml.pickle.parsers",
                         "gnosis.xml.validity",
                         ],
            'licence': "Public Domain"
            }


        # Python 2.0 dies if you pass a 'platforms' arg, but if we
        # leave it out, we get UNKNOWN in PKG-INFO. Our sdist will
        # always be built with Python >= 2.1, so it's not a problem.
        # This keeps us from bombing when installing on Python 2.0.
        if int(sys.version_info[0]) >= 2 and \
           int(sys.version_info[1]) >= 1:
            kwargs['platforms'] = 'Any'
        apply(setup,[],kwargs)
        return 1
    except:
        return 0

# by default, we copy EVERYTHING from MANIFEST to build/lib*.
# this has the nice side-effect of converting all text files
# to the platform text format. setting this to zero means we
# only copy files NOT already under build/lib*
copy_all_files = 1

def copy_extra_files():
    destroot = glob.glob(os.path.join('build','lib'))[0]

    # go through MANIFEST to see what is supposed to be under build directory
    print "Copying extra files to %s ..." % destroot

    f = open('MANIFEST','r')
    for srcfile in f.readlines():
        srcfile = srcfile.rstrip() # remove newline char(s)
        dest = os.path.join(destroot,os.path.normpath(srcfile))
        if not os.path.exists(dest) or copy_all_files:
            dir,file = os.path.split(dest)
            if file == 'setup_gnosis.py':
                continue # skip
            makepath(dir)
            open(dest,'w').write(open(srcfile,'r').read())

if 'install' in sys.argv:
    if not os.path.isdir('build'):
        print "** Please run build command first **"
        sys.exit(1)
    copy_extra_files()

if do_setup() != 1:
    print "** ERROR: setup() failed"
    sys.exit(1)

if not is_DOM_okay():
    print ""
    print "** WARNING: xml.dom.minidom is not working."
    print "**       Some portions of the package will not work."
    print "**       If you are using Python 2.0, you should install PyXML:"
    print "**           http://pyxml.sourceforge.net/topics/download.html"
    print ""

