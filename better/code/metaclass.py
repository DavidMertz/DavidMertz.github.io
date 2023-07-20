from math import sqrt
import os
import logging

log_level = os.environ.get("APP_LOG_LEVEL", 20)
logging.basicConfig(filename='app.log', level=log_level)

class PluginLoggerMeta(type):  # Inherited from, not a metaclass of type
    def __init__(cls, name, bases, attrs):
        logging.info(f"Registering: {name}"
                     f"({', '.join(b.__name__ for b in bases)}): "
                     f"\n  contains: {', '.join(attrs.keys())}")

class Plugin(metaclass=PluginLoggerMeta):
    pass

if True:  # In production some other external condition
    class Point2d(tuple, Plugin):
        def __new__(self, x, y):
            return tuple.__new__(self, (x, y))

        @property
        def distance(self):
            return sqrt(self[0]**2 + self[1]**2)


class Point3d(tuple, Plugin):
    def __new__(self, x, y, z):
        return tuple.__new__(self, (x, y, z))

    @property
    def distance(self):
        return sqrt(self[0]**2 + self[1]**2 + self[2]**2)

print(Point2d(4, 5).distance, Point3d(3, 5, 7).distance)
