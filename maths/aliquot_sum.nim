## Aliquot sum
##
## In number theory, the aliquot sum s(n) of a positive integer n is the sum of
## all proper divisors of n, that is, all divisors of n other than n itself.
##
## For example:
## - s(12) = 1 + 2 + 3 + 4 + 6 = 16
## - s(1) = 0 (since 1 has no proper divisors)
##
## This function determines whether a positive integer is perfect (s(n) = n), abundant (s(n) > n), or deficient (s(n) < n).
##
## Reference:
## https://en.wikipedia.org/wiki/Aliquot_sum

runnableExamples:
  import std/strformat
  const expected = [16, 117]
  for i, number in [12, 100].pairs():
    let sum = aliquotSum(number)
    assert sum == expected[i]
    echo fmt"The sum of all the proper divisors of {number} is {sum}"

func aliquotSum*(number: Positive): Natural =
  ## Compute the aliquot sum of a positive integer.
  ##
  ## Input:
  ## - number: a positive integer (number > 0)
  ## Output:
  ## - The sum of all proper divisors of 'number'
  ## Time Complexity: O(number)
  ## Space Complexity: O(1)
  result = 0
  # A proper divisor p satisfies `number = pq` with q greater than or equal to 2
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
