# -*- coding: utf-8  -*-

__version__ = '$Id: meta_family.py,v 1.5 2005/10/20 10:25:54 wikipedian Exp $'

import family

# The meta family

class Family(family.Family):
    def __init__(self):

        self.name = 'meta'

        family.Family.__init__(self)
        self.langs = {
            'meta': 'meta.wikimedia.org',
        }
        
        self.namespaces[4] = {
            '_default': 'Meta',
        }
        self.namespaces[5] = {
            '_default': 'Meta talk',
        }
