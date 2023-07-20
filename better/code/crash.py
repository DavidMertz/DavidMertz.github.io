import os

fh = open("crash.txt", mode="w")
fh.write("Hello, world!\n")
fh.flush()
fh.write("Goodbye!\n")
os._exit(1)
fh.close()
