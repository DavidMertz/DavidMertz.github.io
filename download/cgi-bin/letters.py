#!/usr/bin/env python
from glob import glob
import sys

def get_words():
    from cPickle import load, dump
    try:
        wdct = load(open('/usr/local/share/scrabble.pickle'))
    except (IOError, EOFError):
        print >> sys.stderr, "Re-generating pickle"
        words = open('/usr/local/share/scrabble').read().split()
        wdct = dict([(i,[]) for i in range(30)])
        for word in words:
            wdct[len(word)].append(word)
        dump(wdct, open('/usr/local/share/scrabble.pickle','w'), protocol=2)
    return wdct

def findwords(s, word_dict=get_words()):
    letters = {}
    for l in s.replace('.',''):
        letters[l] = 1 + letters.get(l, 0)

    for word in word_dict[len(s)]:
         goodcount = True
         for l, n in letters.items():
             if word.count(l) < n:
                 goodcount = False
                 break

         if goodcount:
             yield word

if __name__=='__main__':
    words = list(findwords(sys.argv[1]))
    if words:
        print "\n".join(sorted(words))
