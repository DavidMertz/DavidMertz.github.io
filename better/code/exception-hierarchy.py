def asciiDocTree(cls, level=1):
    print (f"{'*' * level} {cls.__module__}.{cls.__name__}")
    for i in cls.__subclasses__():
        asciiDocTree(i, level+1)

print("""[INFO]
.Hierarchy of built-in exceptions
====""")
asciiDocTree(BaseException)
print("====")
