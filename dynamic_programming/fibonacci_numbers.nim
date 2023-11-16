## Fibonacci Numbers
## ===========================================================================
## Fibonacci numbers are numbers that are part of the Fibonacci sequence.
## The Fibonacci sequence generally starts with 0 and 1, every next number
## is the sum of the two preceding numbers:
##   - F(0) = 0;
##   - F(1) = 1;
##   - F(n) = F(n-1) + F(n-2);
##
##  References:
##    - https://en.wikipedia.org/wiki/Fibonacci_sequence
##    - https://oeis.org/A000045
{.push raises: [].}

runnableExamples:

  doAssert fibonacciSeqIterative(5) == @[Natural(0), 1, 1, 2, 3]

  doAssert fibonacciClosure(4) == Natural(3)

  for f in fibonacciIterator(1.Natural..4.Natural):
    echo f # 1, 1, 2, 3

import std/math

type
  fibMatrix = array[2, array[2, int]]

func `*`(m1, m2: fibMatrix): fibMatrix =
  let
    a = m1[0][0] * m2[0][0] + m1[0][1] * m2[1][0]
    b = m1[0][0] * m2[0][1] + m1[0][1] * m2[1][1]
    z = m1[1][0] * m2[0][0] + m1[1][1] * m2[1][0]
    y = m1[1][0] * m2[0][1] + m1[1][1] * m2[1][1]

  [[a, b], [z, y]]

func pow(matrix: fibMatrix, n: Natural): fibMatrix =
  ## binary matrix exponentiation (divide-and-conquer approach)
  if n in {0, 1}:
    matrix
  elif n mod 2 == 0:
    let halfPow = matrix.pow(n div 2)
    halfPow * halfPow
  else:
    matrix * matrix.pow(n-1)

func fibonacciMatrix*(nth: Natural): Natural =
  ## Calculates the n-th fibonacci number with use of matrix arithmetic.
  if nth <= 1: return nth
  var matrix = [[1, 1],
                [1, 0]]
  matrix.pow(nth - 1)[0][0]

func fibonacciRecursive*(nth: Natural): Natural =
  ## Calculates the n-th fibonacci number in a recursive manner.
  ## Recursive algorithm is extremely slow for bigger numbers of n.
  if nth <= 1: return nth
  fibonacciRecursive(nth-2) + fibonacciRecursive(nth-1)

func makeFibClosure(): proc(): Natural =
  ## Closure constructor. Returns procedure which can be called to get
  ## the next fibonacci number, starting with F(2).
  var prev = 0
  var current = 1
  proc(): Natural =
    swap(prev, current)
    current += prev
    result = current

proc fibonacciClosure*(nth: Natural): Natural =
  ## Calculates the n-th fibonacci number with use of a closure.
  if nth <= 1: return nth
  let fib = makeFibClosure()
  for _ in 2..<nth:
    discard fib()
  fib()

proc fibonacciSeqClosure*(n: Positive): seq[Natural] =
  ## Generates a list of n first fibonacci numbers with use of a closure.
  result = newSeq[Natural](n)
  result[0] = 0
  if n > 1:
    result[1] = 1
    let fib = makeFibClosure()
    for i in 2..<n:
      result[i] = fib()

func fibonacciSeqIterative*(n: Positive): seq[Natural] =
  ## Generates a list of n first fibonacci numbers in iterative manner.
  result = newSeq[Natural](n)
  result[0] = 0
  if n > 1:
    result[1] = 1
    for i in 2..<n:
      result[i] = result[i-1] + result[i-2]

func fibonacciBinet*(nth: Natural): Natural =
  ## Approximates the n-th fibonacci number in constant time O(1) with use of Binet's formula.
  ## Will be incorrect for large numbers of n, due to rounding error.
  const Sqrt5 = sqrt(5'f)
  const Phi = (Sqrt5 + 1) / 2 # golden ratio
  let powPhi = pow(Phi, nth.float)
  Natural(powPhi/Sqrt5 + 0.5)

iterator fibonacciIterator*(s: HSlice[Natural, Natural]): Natural =
  ## Nim iterator.
  ## Returns fibonacci numbers from F(s.a) to F(s.b).
  var prev = 0
  var current = 1
  for i in 0..s.b:
    if i <= 1:
      if i >= s.a: yield i
    else:
      swap(prev, current)
      current += prev
      if i >= s.a: yield current

when isMainModule:
  import std/unittest
  import std/sequtils
  import std/sugar

  const
    LowerNth: Natural = 0
    UpperNth: Natural = 31
    OverflowNth: Natural = 93

    Count = 32
    OverflowCount = 94

    HighSlice = Natural(32)..Natural(40)

    Expected = @[Natural(0), 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377,
                 610, 987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368,
                 75025, 121393, 196418, 317811, 514229, 832040, 1346269]
      ## F0 .. F31
    ExpectedHigh = @[Natural(2178309), 3524578, 5702887, 9227465, 14930352,
                     24157817, 39088169, 63245986, 102334155]
      ## F32 .. F40

  template checkFib(list: openArray[Natural]) =
    check list == Expected

  template checkFib(calcTerm: proc(n: Natural): Natural,
                    range = LowerNth..UpperNth) =
    let list = collect(for i in range: calcTerm(i))
    check list == Expected

  template checkFibOverflow(code: typed) =
    expect OverflowDefect:
      discard code

  suite "Fibonacci Numbers":
    test "F0..F31 - Recursive Version":
      checkFib(fibonacciRecursive)
    test "F0..F31 - Closure Version":
      checkFib(fibonacciClosure)
    test "F0..F31 - Matrix Version":
      checkFib(fibonacciMatrix)
    test "F0..F31 - Iterative Sequence Version":
      checkFib(fibonacciSeqIterative(Count))
    test "F0..F31 - Closure Sequence Version":
      checkFib(fibonacciSeqClosure(Count))
    test "F0..F31 - Constant Time Formula":
      checkFib(fibonacciBinet)
    test "F0..F31 - Nim Iterator":
      checkFib(fibonacciIterator(LowerNth..UpperNth).toSeq)

    test "Constant Time Formula fails when nth >= 32":
      let list = collect(for i in HighSlice: fibonacciBinet(i))
      check list != ExpectedHigh

    #test "Recursive procedure overflows when nth >= 93":   # too slow at this point
    #  checkFibOverflow(fibonacciRecursive)
    test "Closure procedure overflows when nth >= 93":
      checkFibOverflow(fibonacciClosure(OverflowNth))
    test "Matrix procedure overflows when nth >= 93":
      checkFibOverflow(fibonacciMatrix(OverflowNth))
    test "Iterative Sequence function overflows when n >= 94":
      checkFibOverflow(fibonacciSeqIterative(OverflowCount))
    test "Closure Sequence procedure overflows when n >= 94":
      checkFibOverflow(fibonacciSeqClosure(OverflowCount))
    test "Nim Iterator overflows when one or both slice indexes >= 93":
      checkFibOverflow(fibonacciIterator(LowerNth..OverflowNth).toSeq())
