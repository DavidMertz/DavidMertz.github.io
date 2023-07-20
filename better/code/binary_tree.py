"""A partial implementation of a "counting" binary tree"""


# Sentinel for an unused node
class Empty:
    length = 0

    def __repr__(self):
        return "EMPTY"

    def tree(self, indent=0):
        print(f"{'· '*indent}EMPTY")


EMPTY = Empty()


class CountingTree:
    def __init__(self, value=EMPTY):
        self.left = EMPTY
        self.right = EMPTY
        self.value = value
        self.length = 0 if value is EMPTY else 1

    def insert(self, index: int, value):
        if index != 0 and not 0 < index <= self.length:
            raise IndexError(f"CountingTree index {index} out of range in {self}")

        if self.value is EMPTY:
            self.value = value
        elif index == self.length:
            if self.right is EMPTY:
                self.right = CountingTree(value)
            else:
                self.right.insert(index - (self.left.length + 1), value)
        elif index == 0 and self.left is EMPTY:
            self.left = CountingTree(value)
        else:
            if index > self.left.length:
                self.right.insert(index - (self.left.length + 1), value)
            else:
                self.left.insert(index, value)

        self.length += 1

    def append(self, value):
        self.insert(len(self), value)

    def __iter__(self):
        if self.left is not EMPTY:
            yield from self.left
        if self.value is not EMPTY:
            yield self.value
        if self.right is not EMPTY:
            yield from self.right

    def __repr__(self):
        return f"CountingTree({list(self)})"

    def __len__(self):
        return self.length

    def tree(self, indent=0):
        print(f"{'· '*indent}{self.value}")
        if self.left is not EMPTY or self.right is not EMPTY:
            self.left.tree(indent+1)
            self.right.tree(indent+1)


if __name__ == "__main__":
    from random import randint, choice, seed
    seed("custom counting binary tree")
    ct = CountingTree()
    lst = list()
    letters = "ABCDEFGHIJKLM"

    for _ in range(25):
        pos = randint(0, len(lst))
        let = choice(letters)
        ct.insert(pos, let)
        lst.insert(pos, let)
        if lst != list(ct):
            print(f"Inserted {pos} {let}")
            print(f"      list   {lst}\n{ct}")
            break

    ct.tree()
