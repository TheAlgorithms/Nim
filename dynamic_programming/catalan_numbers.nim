# Catalan Numbers
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
  for i in 0 ..< index:
    result += catalanNumbersRecursive(i) *
     catalanNumbersRecursive(index - i - 1)

func catalanNumbersRecursive2(index: Natural): Positive =
  if index < 2:
    return 1
  else:
    2 * (2 * index - 1) * catalanNumbersRecursive2(index - 1) div (index + 1)

func catalanNumbers(indexLimit: Natural): seq[Positive] {.noinit.} =
  ## Returns all Catalan numbers up to the index-th number iteratively.
  result = newSeq[Positive](indexLimit + 1)
  result[0] = 1
  for i in 1 .. indexLimit:
    for j in 0 ..< i:
      result[i] += result[j] * result[i - j - 1]

func catalanNumbers2(index: Natural): Positive =
  ## Returns the index-th Catalan number iteratively with a second formula.
  ## This function is not efficient.
  binom(2 * index, index) div (index + 1)

iterator catalanNumbersIt(index: Natural): Positive =
  ## Iterates over all Catalan numbers up to the index-th number.
  var catalanNumbers = newSeq[Positive](index + 1)
  catalanNumbers[0] = 1
  for i in 0 .. index:
    for j in 0 ..< i:
      catalanNumbers[i] += catalanNumbers[j] * catalanNumbers[i - j - 1]
    yield catalanNumbers[i]

func createCatalanTable(N: static[Natural]): array[N, Positive] =
  ## Creates a table of Catalan numbers up to the 37th number.
  if N > 36:
    raise newException(OverflowDefect, "N must be less than 36")
  result[0] = 1
  for i in 1 ..< N:
    for j in 0 ..< i:
      result[i] += result[j] * result[i - j - 1]

func catalanNumber(index: Natural): Positive =
  when sizeof(int) == 2:
    const catalanTable = createCatalanTable(12)
  when sizeof(int) == 4:
    const catalanTable = createCatalanTable(20)
  when sizeof(int) == 8: 
    const catalanTable = createCatalanTable(36)
  catalanTable[index-1]

when isMainModule:
  import std/unittest

  let expectedResult: seq[Positive] = @[1, 1, 2, 5, 14, 42, 132, 429,
                                        1430, 4862, 16796, 58786, 208012,
                                        742900, 2674440, 9694845]
  const CatalanNumbersList = [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796,
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
    test "The twelve first Catalan numbers":
      check catalan_numbers(15) == expectedResult
    
    test "The sixteen first Catalan numbers with iterator":
      let n = 15
      var i = 0
      for catalan_number in catalan_numbers_it(n):
        check catalan_number == expectedResult[i]
        inc i
    
    test "Uses compile-time table":
      check catalan_number(36) == Positive(3116285494907301262)
