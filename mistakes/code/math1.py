from math import *
from cmath import *
from numpy import *

inf = float("inf")
for fn, num in zip([sqrt, ceil, isfinite], [-1, 4.5, inf * 1j]):
    try:
        print(f"{fn.__name__}({num}) -> {fn(num)}")
    except Exception as err:
        print(err)
