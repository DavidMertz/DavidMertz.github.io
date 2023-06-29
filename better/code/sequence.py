from typing import Sequence


def double_middle_element(seq: Sequence[int]) -> Sequence[int]:
    if len(seq) > 0:
        middle = len(seq) // 2
        item = seq[middle] * 2
        new = seq[:middle] + type(seq)([item]) + seq[middle + 1 :]
    return new


a = double_middle_element((5, 8, 4, 6, 2, 3))
print(a)

b = double_middle_element([5, 8, 4, 6, 2, 3])
print(b)
