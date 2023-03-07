class LinearCongruentialGenerator:
    def __init__(self, seed: int=123):
        self.__seed: int = seed
        self._multiplier: int = 1103515245
        self._modulus: int = 2**32
        self._increment: int = 1

        # Simple constraints we should follow
        assert 0 < self._modulus
        assert 0 < self._multiplier < self._modulus
        assert 0 <= self._increment < self._modulus
        assert 0 <= seed < self._modulus

        # One initial application of recurrence relation
        self._state = (
            (self._multiplier * self.__seed + self._increment)
            % self._modulus)

    @property
    def seed(self):
        return self.__seed

    def next(self):
        # Increment the state
        self._state = (
            (self._multiplier * self._state + self._increment)
            % self._modulus)
        return self._state / self._modulus

