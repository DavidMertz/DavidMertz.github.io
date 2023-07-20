def bad_lcg(
    seed: int = 123,
    multiplier: int = 1_103_515_245,
    modulus: int = 2**32,
    increment: int = 1
):
    # Skip LCG algorithm if parameters are not usable
    try:
        assert 0 < modulus
        assert 0 < multiplier < modulus
        assert 0 <= increment < modulus
        assert 0 <= seed < modulus

        # One initial application of recurrence relation
        state = (multiplier * seed + increment) % modulus

        while True:
            state = (multiplier * state + increment) % modulus
            yield state / modulus

    except AssertionError:
        import random
        while True:
            yield random.random()


if __name__ == '__main__':
    for x, _ in zip(bad_lcg(multiplier=-1), range(5)):
        print(x)
