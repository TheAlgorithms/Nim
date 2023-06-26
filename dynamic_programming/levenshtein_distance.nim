## Levenshtein distance

import tables


func initSubsolutions(lenA, lenB: Natural): Table[(Natural, Natural), Natural] =
  for indA in 0.Natural..lenA:
    result[(indA, 0.Natural)] = indA

  for indB in 1.Natural..lenB:
    result[(0.Natural, indB)] = indB


func toKey(indA: int, indB: int): (Natural, Natural) =
  return (Natural(indA), Natural(indB))


func computeLevenshteinDistanceMatrix(a, b: string): Table[(Natural, Natural),
                                                           Natural] =
  result = initSubsolutions(a.len, b.len)

  for indA in 0..<a.len:
    for indB in 0..<b.len:
      let substitutionCost = (if a[indA] == b[indB]: 0 else: 1)
      result[toKey(indA + 1, indB + 1)] = min(
          [result[toKey(indA, indB + 1)] + 1,
           result[toKey(indA + 1, indB)] + 1,
           result[toKey(indA, indB)] + substitutionCost])


func levenshteinDistance*(strA: string, strB: string): Natural =
  ## Returns the
  ## [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)
  ## between the input strings.
  ## This implementation utilises dynamic programming.
  runnableExamples:
    doAssert levenshteinDistance("abc", "aXcY") == 2
  return computeLevenshteinDistanceMatrix(strA, strB)[toKey(strA.len, strB.len)]


when isMainModule:
  import std/unittest

  suite "levenshteinDistance":

    type
      TestCase = object
        strA*, strB*: string
        distance*: Natural

    const testCases = @[
      TestCase(strA: "", strB: "", distance: Natural(0)),
      TestCase(strA: "", strB: "a", distance: Natural(1)),
      TestCase(strA: "a", strB: "a", distance: Natural(0)),
      TestCase(strA: "a", strB: "ab", distance: Natural(1)),
      TestCase(strA: "saturday", strB: "sunday", distance: Natural(3)),
      TestCase(strA: "kitten", strB: "sitting", distance: Natural(3)),
      TestCase(strA: "abcdefghif", strB: "abCdeFghIfX", distance: Natural(4)),
      TestCase(strA: "abc", strB: "aXcY", distance: Natural(2)),
      ]

    test "returns expected result":
      for tc in testCases:
        check tc.distance == levenshteinDistance(tc.strA, tc.strB)

    test "is symmetric":
      for tc in testCases:
        check tc.distance == levenshteinDistance(tc.strB, tc.strA)
