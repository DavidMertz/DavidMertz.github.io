from __future__ import generators
import random

def randomwalk_static(last=[1]):    # init the "static" var(s)
    rand = random.random()          # init a candidate value
    if last[0] < 0.1:               # threshhold terminator
        return None                 # end-of-stream flag
    while abs(last[0]-rand) < 0.4:  # look for usable candidate
        print '*',                  # display the rejection
        rand = random.random()      # new candidate
    last[0] = rand                  # update the "static" var
    return rand

def randomwalk_list():
    last, rand = 1, random.random() # initialize candidate elements
    nums = []                       # empty list
    while rand > 0.1:               # threshhold terminator
        if abs(last-rand) >= 0.4:   # accept the number
            last = rand
            nums.append(rand)       # add latest candidate to nums
        else:
            print '*',              # display the rejection
        rand = random.random()      # new candidate
    nums.append(rand)               # add the final small element
    return nums

class randomwalk_iter:
    def __init__(self):
        self.last = 1               # init the prior value
        self.rand = random.random() # init a candidate value
    def __iter__(self):
        return self                 # simplest way to create iterator
    def next(self):
        if self.rand < 0.1:         # threshhold terminator
            raise StopIteration     # end of iteration
        else:                       # look for usable candidate
            while abs(self.last-self.rand) < 0.4:
                print '*',          # display the rejection
                self.rand = random.random() # new candidate
            self.last = self.rand   # update prior value
            return self.rand

def randomwalk_generator():
    last, rand = 1, random.random() # initialize candidate elements
    while rand > 0.1:               # threshhold terminator
        print '*',                  # display the rejection
        if abs(last-rand) >= 0.4:   # accept the number
            last = rand             # update prior value
            yield rand              # return AT THIS POINT
        rand = random.random()      # new candidate
    yield rand                      # return the final small element

def print_short(num): print round(num,3),

if __name__=='__main__':
    print '----- Random Walk Class Iterator -----'
    for num in randomwalk_iter():
        print_short(num)
    print
    
    print '----- Random Walk Static Function -----'
    num = randomwalk_static()
    while num is not None:
        print_short(num)
        num = randomwalk_static()
    print

    print '----- Random Walk Completion List -----'
    # map(print_short,randomwalk_list())
    for num in randomwalk_list():
        print_short(num)
    print

    print '----- Manual use of Random Walk Generator -----'
    gen = randomwalk_generator()
    try:
        while 1: print_short(gen.next())
    except StopIteration:
        print

    print '----- Random Walk Generator as Interator -----'
    for num in randomwalk_generator():
        print_short(num)
    print
    
    if 5 not in randomwalk_iter(): print 'wow'
