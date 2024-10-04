proc ceil(x: float): int =
  ##
  ## Return the ceiling of x as an Integral.
  ## Wiki: https://en.wikipedia.org/wiki/Floor_and_ceiling_functions
  ##
  ## :param x: the number
  ## :return: the smallest integer >= x.
  ##
  ## Example:
  ## ```nim
  ## import math
  ## echo all(ceil(n) == int(math.ceil(n)) for n in [1.0, -1.0, 0.0, -0.0,
  ##                                                 1.1, -1.1, 1.0, -1.0,
  ##                                                 1_000_000_000.0])
  ## # Output: true
  ## ```
  if x - int(x) <= 0:
    result = int(x)
  else:
    result = int(x) + 1

when isMainModule:
  import unittest, math

  suite "Test ceil function":
    test "Ceil correctness":
      let nums = [1.0, -1.0, 0.0, -0.0, 1.1, -1.1, 1.0, -1.0, 1_000_000_000.0]
      check all(ceil(n) == int(math.ceil(n)) for n in nums)
