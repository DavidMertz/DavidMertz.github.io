#!/usr/bin/env python
import sys

def subseq(seq, minlen=1, top=True):
    if top:
        global seen
        seen = set()
    if seq not in seen:
        seen.add(seq)
        yield seq
        if len(seq) > minlen:
            for c in seq:
                sub = seq.replace(c,'',1)
                if sub not in seen:
                    yield sub
                for subsub in subseq(sub, minlen, top=False):
                    yield subsub


if __name__=='__main__':
    print "\n".join(sorted(subseq(sys.argv[1]), key=len, reverse=True))

