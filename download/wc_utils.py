from string import split

def wc(s):
    return len(split(s,'\n')), len(split(s)), len(s)

def histogram(s):
    hist = {}
    for word in split(s):
        hist[word] = hist.get(word, 0)+1
    return hist

def top10(hist):
    entries = []
    for word, cnt in hist.items():
        entries.append((cnt, word))
    entries.sort()
    entries.reverse()
    return entries[:10]



