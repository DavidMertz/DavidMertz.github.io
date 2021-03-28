#/usr/bin/env python2.3
from datetime import datetime, timedelta
start = "2003 07 25 16 4".split()
end = "2004 07 16 15 28".split()
sites = ['basement','lab','livingroom','outside']

def timesteps(start, end, mins):
    ts = datetime(*map(int, start))
    end = datetime(*map(int, end))
    incr = timedelta(minutes=mins)
    while ts <= end:
        yield ts
        ts += incr

data = []
for file in [open(site).readlines() for site in sites]:
    data.append({})
    for line in file:
        ts = datetime(*map(int, line[:17].split()))
        temp = line[17:].rstrip()
        data[-1][ts] = temp

print "timestamp".center(16), " ".join([s.center(10) for s in sites]),
for ts in timesteps(start, end, 3):
    print "\n%s" % ts.isoformat()[:-3],
    for datedict in data:
        print str(datedict.get(ts, "NA")).center(10),
