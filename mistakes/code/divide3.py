#!/usr/bin/env python
import sys

numerators = sys.argv[1]
denominators = sys.argv[2]

try:
    ratios = []
    num_fh = open(numerators)
    den_fh = open(denominators)
    line = 0
    for string_a, string_b in zip(num_fh, den_fh, strict=True):
        line += 1
        a = float(string_a.strip())
        b = float(string_b.strip())
        ratios.append(a / b)
    print([f"{r:.3f}" for r in ratios])
except ZeroDivisionError:
    print(f"Partial results: {[f'{r:.3f}' for r in ratios]}")
    print(f"Attempt to divide by zero at input line {line}")
except ValueError as err:
    print(f"Partial results: {[f'{r:.3f}' for r in ratios]}")
    desc = err.args[0]
    if "zip()" in desc:
        print(desc)
    elif "could not convert" in desc:
        print(f"String is not numeric at input line {line}")
except PermissionError:
    print(f"Partial results: {[f'{r:.3f}' for r in ratios]}")
    print("Insufficient permission to file(s). Run as sudo?")
except FileNotFoundError as err:
    print(f"Partial results: {[f'{r:.3f}' for r in ratios]}")
    print(f"File {err.filename} does not exist")
except OSError as err:
    # Superclass after PermissionError and FileNotFoundError
    print(f"Partial results: {[f'{r:.3f}' for r in ratios]}")
    print(err)
finally:
    try:
        num_fh.close()
        den_fh.close()
    except NameError:
        # Opened in same order as closed, if failure with open()
        # on second, the first file will still get closed here.
        pass
