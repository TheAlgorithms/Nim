## Aliquot sum
## In number theory, the aliquot sum s(n) of a positive integer n is the sum of
## all proper divisors of n, that is, all divisors of n other than n itself.
## https://en.wikipedia.org/wiki/Aliquot_sum

runnableExamples:
  import std/strformat
  const expected = [16, 117]
  for i, number in [12, 100].pairs():
    let sum = aliquotSum(number)
    assert sum == expected[i]
    echo fmt"The sum of all the proper divisors of {number} is {sum}"

func aliquotSum*(number: Positive): Natural =
  ## Returns the sum of all the proper divisors of the number
  ## Example: aliquotSum(12) = 1 + 2 + 3 + 4 + 6 = 16
  result = 0
  for divisor in 1 .. (number div 2):
    if number mod divisor == 0:
      result += divisor

when isMainModule:
  import std/unittest
  suite "Check aliquotSum":
    test "aliquotSum on small values":
      var
        input = @[1, 2, 9, 12, 27, 100]
        expected = @[0, 1, 4, 16, 13, 117]
      for i in 0 ..< input.len:
        check:
          aliquotSum(input[i]) == expected[i]
