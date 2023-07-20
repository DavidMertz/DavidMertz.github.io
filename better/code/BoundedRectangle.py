from sys import stderr
from math import sqrt


class BoundedRectangle:
    def __init__(self, x, y, radius=1):
        assert x > 0 and y > 0 and radius > 0
        assert sqrt(x**2 + y**2) <= radius
        self._x = x
        self._y = y
        self._radius = radius

    @property
    def x(self):
        return self._x

    @x.setter
    def x(self, new_x):
        if new_x < 0 or sqrt(new_x**2 + self._y**2) > self._radius:
            print("Rectangle bounds violated", file=stderr)
            return
        self._x = new_x

    @property
    def y(self):
        return self._y

    @y.setter
    def y(self, new_y):
        if new_y < 0 or sqrt(new_y**2 + self._x**2) > self._radius:
            print("Rectangle bounds violated", file=stderr)
            return
        self._y = new_y

    @property
    def area(self):
        return self._x * self._y
