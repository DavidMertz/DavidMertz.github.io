import re
from re import match as _match


def match_positive(pat, s, flags=0):
    return _match(rf"\+{pat}", s, flags)


re.match = match_positive

