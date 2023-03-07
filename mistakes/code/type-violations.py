# type-violations.py
from typing import TypeVar

Numeric = TypeVar("Numeric", float, complex, contravariant=True)


def fused_multiply_add(a: Numeric, b: Numeric, c: Numeric) -> Numeric:
    r: Numeric = (a * b) + c
    return r


print("fused_multiply_add(1, 2, 3)", end=" -> ")
try:
    print(fused_multiply_add(1, 2, 3))
except Exception as ex:
    print(type(ex))

print("fused_multiply_add('foo', 2, 'bar')", end=" -> ")
try:
    print(fused_multiply_add("foo", 2, "bar"))
except Exception as ex:
    print(type(ex))

print("fused_multiply_add('foo', 2.0, 'bar)", end=" -> ")
try:
    print(fused_multiply_add("foo", 2.0, "bar"))
except Exception as ex:
    print(type(ex))

print("fused_multiply_add(1+1j, 2.0, 3.0)", end=" -> ")
try:
    print(fused_multiply_add(1 + 1j, 2.0, 3.0))
except Exception as ex:
    print(type(ex))
