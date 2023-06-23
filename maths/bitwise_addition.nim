## Bitwise Addition
## Illustrate how to implement addition of integers using bitwise operations
## See https://en.wikipedia.org/wiki/Bitwise_operation#Applications
runnableExamples:
  import std/strformat
  var
    a = 5
    b = 6
  echo fmt"The sum of {a} and {b} is {add(a,b)}"

func add*(first: int, second: int): int =
  ## Implementation of addition of integer with `and`, `xor` and `shl`
  ## boolean operators.
  var first = first
  var second = second
  while second != 0:
    var c = first and second
    first = first xor second
    second = c shl 1
  return first

when isMainModule:
  import std/unittest

  suite "Check addition":
    test "Addition of two positive numbers":
      check:
        add(3, 5) == 8
        add(13, 5) == 18
    test "Addition of two negative numbers":
      check:
        add(-7, -2) == -9
        add(-321, -0) == -321
    test "Addition of one positive and one negative number":
      check:
        add(-7, 2) == -5
        add(-13, 5) == -8
        add(13, -5) == 8
