#!/usr/bin/env python
import sys
numerators = sys.argv[1]
denominators = sys.argv[2]

try:
    ratios = []
    num_fh = open(numerators)
    den_fh = open(denominators)
    for string_a, string_b in zip(num_fh, den_fh, strict=True):
        a = float(string_a.strip())
        b = float(string_b.strip())
        ratios.append(a/b)
    print(ratios)
except Exception as err:
    print(f"Unable to perform divisions:\n    {err}")
    print(f"Partial results: {ratios}")
finally:
    num_fh.close()
    den_fh.close()
