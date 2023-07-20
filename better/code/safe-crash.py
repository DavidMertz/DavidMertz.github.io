import os

with open("crash.txt", mode="w") as fh:
    fh.write("Hello, world!\n")
    fh.flush()
    fh.write("Goodbye!\n")
os._exit(1)
