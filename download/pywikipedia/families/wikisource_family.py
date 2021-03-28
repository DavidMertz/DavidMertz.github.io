# -*- coding: utf-8  -*-
import urllib
import family, config

__version__ = '$Id: wikisource_family.py,v 1.4 2005/10/13 21:00:36 leogregianin Exp $'

# The wikimedia family that is known as Wikisource

class Family(family.Family):
    def __init__(self):
        family.Family.__init__(self)
        self.name = 'wikisource'
       
        for lang in self.knownlanguages:
            self.langs[lang] = lang+'.wikisource.org'
  
        self.namespaces[4] = {
            '_default': u'Wikisource',
        }
        self.namespaces[5] = {
            '_default': u'Wikisource talk',
        }
        
        alphabetic = ['ar','da','de','el','en','es','fr','gl',
                      'he','hr','it','ja', 'ko','la','nl','pl',
                      'pt','ro','ru','sr','sv','zh']
        
        self.cyrilliclangs = ['ru', 'sr']
