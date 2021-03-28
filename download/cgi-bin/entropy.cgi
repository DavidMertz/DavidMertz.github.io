#!/home/98/46/2924698/bin/python2.3

from math import log, floor, ceil
from operator import mul, add
fac = lambda N: reduce(mul, range(1,N+1), 1)
perm = lambda N,M: fac(M)/fac(M-N)
comb = lambda N,M: perm(N,M)/fac(N)
mult_vote = lambda N,M: reduce(add, [comb(i,M) for i in range(1,N+1)], 1)
rank_vote = lambda N,M: reduce(add, [perm(i,M) for i in range(1,N+1)], 1)
sing_vote = lambda N: N+1
SD = lambda n,d: d*ceil(log(n)/log((2**d)/2))

def report(data, alphabet_size):
    possible, comment = [], ''
    for line in data.split('\n'):
        if not line.strip(): continue
        if line.startswith('#'):
            comment += line[1:]
            continue
        opts = line.split()
        type_ = opts[0].upper()
        if   type_=='SINGLE': possible.append(sing_vote(int(opts[1])))
        elif type_=='MULTI':  possible.append(mult_vote(*map(int, opts[1:3])))
        elif type_=='RANKED': possible.append(rank_vote(*map(int, opts[1:3])))
    print comment.lstrip()
    total = reduce(mul,possible)
    print total, "distinct votes are possible"
    entropy = ceil(log(total)/log(2))
    print "Optimal encoding is approximately:   %d bits" % entropy
    logs = [log(p)/log(2) for p in possible]
    per_contest = reduce(add, map(ceil, logs))
    print "Contests at bit-boundaries, approx:  %d bits" % per_contest
    d = ceil(log(alphabet_size)/log(2))
    self_delim = [SD(n,d) for n in possible]
    per_delim = reduce(add, map(ceil, self_delim))
    print "Self-delimited (%d char symbology):  %d bits " \
           % (alphabet_size, per_delim)
    print
    print "Vote Space  Optimal  Self-Delim"
    print "----------  -------  ----------"
    for _ in zip(possible, map(ceil,logs), map(ceil,self_delim)):
        print "%7d         %2d         %2d" % _


import cgitb; cgitb.enable()
import cgi

init = """# Election summary for OVC demo (write-ins count as candidate)
single  8       # Prez, 7 candidates plus write-in
single  8       # Senator
single  3       # Representative
single  3       # Treasurer
single  4       # AG
single  3       # Edu Commis
single  4       # State Senate
single  3       # Assembly
single  2       # Transportation initiative
single  2       # health care
single  2       # term limit
multi   3   10  # Cat Catcher
ranked  8   8   # County Commissioner
"""
form = cgi.FieldStorage()
data = form.getvalue('data',init)
alphabet = form.getvalue('alphabet',8)

print "content-type: text/html"
print 
print """<html>
  <head>
  <title>Election Entropy Calculator</title>
  <body>

  <h1>Election Entropy</h1>
  <h2>Configuration Sample</h2>
  <pre>#TYPE   M of N  # (optional) comments on contest
%s</pre>
  <h2>Election Data to Analyze</h2>
  <form action="http://gnosis.cx/cgi-bin/entropy.cgi" method="POST" >
    <textarea name="data" cols="70" rows="15">%s</textarea>
    <br/>Alphabet Size
    <input type="text" name="alphabet" size="4" value="%s">
    <input type="submit" value="Calculate Entropy"/>
  </form> 
  <h2>Report</h2>
  <pre>""" % (init, data, alphabet) 
report(data, int(alphabet))
print "</pre></body></html>"

