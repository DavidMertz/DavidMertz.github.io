# The special path manipulation
import sys, os

if "code" not in os.path.abspath("."):
    sys.path = [p for p in sys.path if "PythonMistakes" not in p]

# The "regular" program
import re

pat = re.compile("hello", re.I)
s = "Hello World!"
if re.match(pat, s):
    print(s)
