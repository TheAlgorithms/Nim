## Catalan Numbers
#[
    The Catalan numbers are a sequence of natural numbers that occur in the
    most large set of combinatorial problems.
    For example, it describes:
    - the number of ways to parenthesize a product of n factors
    - the number of ways to form a binary search tree with n+1 leaves
    - the number of Dyck paths of length 2n
    - the number of ways to triangulate a convex polygon with n+2 sides
    References:
    https://en.wikipedia.org/wiki/Catalan_number
    https://oeis.org/A000108
]#
import std/math
{.push raises: [].}

func catalanNumbersRecursive(index: Natural): Positive =
  ## Returns the index-th Catalan number recursively.
  ## As Nim does not make automatic memoization, this function is not
  ## efficient.
  if index < 2:
    return 1
  var n: Natural = 0
  for i in 0 ..< index:
    n += catalanNumbersRecursive(i) * catalanNumbersRecursive(index - i - 1)
  n

func catalanNumbersRecursive2(index: Natural): Positive =
  if index < 2:
    return 1
  else:
    2 * (2 * index - 1) * catalanNumbersRecursive2(index - 1) div (index + 1)

func catalanNumbers(indexLimit: Natural): seq[Positive] {.noinit.} =
  ## Returns all Catalan numbers up to the index-th number iteratively.
  result = newSeq[Positive](indexLimit)
  result[0] = 1
  for i in 1 ..< indexLimit:
    for j in 0 ..< i:
      result[i] += result[j] * result[i - j - 1]

func catalanNumbers2(index: Natural): Positive =
  ## Returns the index-th Catalan number iteratively with a second formula.
  ## Due to the division, this formula overflows at the 30th Catalan number.
  binom(2 * index, index) div (index + 1)

iterator catalanNumbersIt(index: Natural): Positive =
  ## Iterates over all Catalan numbers up to the index-th number.
  var catalanNumbers = newSeq[Positive](index)
  catalanNumbers[0] = 1
  for i in 0 ..< index:
    for j in 0 ..< i:
      catalanNumbers[i] += catalanNumbers[j] * catalanNumbers[i - j - 1]
    yield catalanNumbers[i]

func createCatalanTable(index: static[Natural]): array[index, Positive] =
  ## Creates a table of Catalan numbers up to the index-th number.
  when index > 36:
    raise newException(OverflowDefect, "Index must be less or equal than 36")
  result[0] = 1
  for i in 1 ..< index:
    for j in 0 ..< i:
      result[i] += result[j] * result[i - j - 1]

func catalanNumbersCompileTime(index: Natural): Positive =
  if index > 36:
    raise newException(OverflowDefect, "N must be less or equal than 36")
  when sizeof(int) == 2:
    const catalanTable = createCatalanTable(12)
  when sizeof(int) == 4:
    const catalanTable = createCatalanTable(20)
  when sizeof(int) == 8:
    const catalanTable = createCatalanTable(36)
  catalanTable[index-1]

when isMainModule:
  import std/unittest

  const RecursiveLimit = 16 # The first recursive formula gets too slow above 16
  const LowerLimit = 30 # The formulas involving a division overflows above 30
  const UpperLimit = 36 # Other methods overflow above 36

  let expectedResult: seq[Positive] = @[Positive(1), 1, 2, 5, 14, 42, 132, 429,
                                        1430, 4862, 16796, 58786, 208012,
                                        742900, 2674440, 9694845]
  const CatalanNumbersList: seq[Positive] = @[Positive(1), 1, 2, 5, 14, 42, 132,
      429, 1430, 4862, 16796,
    58786, 208012, 742900, 2674440, 9694845, 35357670, 129644790, 477638700,
    1767263190, 6564120420, 24466267020, 91482563640, 343059613650,
    1289904147324, 4861946401452, 18367353072152, 69533550916004,
    263747951750360, 1002242216651368, 3814986502092304, 14544636039226909,
    55534064877048198, 212336130412243110, 812944042149730764,
    3116285494907301262]

  static:
    for i in 0 ..< 36:
      doAssert (CatalanNumbersList[i] == createCatalanTable(36)[i])

  suite "Catalan Numbers":
    test "The seventeen first Catalan numbers recursively, first formula":
      let limit = RecursiveLimit
      for index in 0 .. limit:
        let catalanNumber = catalanNumbersRecursive(index)
        check catalanNumber == CatalanNumbersList[index]

    test "The thirty-one first Catalan numbers recursively, second formula":
      let limit = LowerLimit
      for index in 0 .. limit:
        let catalanNumber = catalanNumbersRecursive2(index)
        check catalanNumber == CatalanNumbersList[index]

    test "The sixteen first Catalan numbers iteratively":
      check catalanNumbers(16) == expectedResult

    test "We can compute up to the thirty-seventh Catalan number iteratively":
      let limit = UpperLimit
      let catalanNumbersSeq = catalanNumbers(limit)
      for index in 0 ..< limit:
        check catalanNumbersSeq[index] == CatalanNumbersList[index]

    test "The thirty-seventh first Catalan numbers with iterator":
      let limit = UpperLimit
      var index = 0
      for catalanNumber in catalanNumbersIt(limit):
        check catalanNumber == CatalanNumbersList[index]
        inc index

    test "Test the catalan number function with binomials":
      let limit = LowerLimit
      for index in 0 .. limit:
        check catalanNumbers2(index) == CatalanNumbersList[index]

    test "The Catalan Numbers binomial formula overflows at 31":
      doAssertRaises(OverflowDefect):
        discard catalanNumbers2(LowerLimit + 1)

    test "Uses compile-time table":
      check catalanNumbersCompileTime(UpperLimit) == Positive(3116285494907301262)

    test "The compile-time table overflows at 37":
      doAssertRaises(OverflowDefect):
        discard catalanNumbersCompileTime(UpperLimit + 1)
