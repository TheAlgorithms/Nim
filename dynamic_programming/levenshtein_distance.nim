## Levenshtein distance

import tables

type Key = (Natural, Natural)


func toKey(indA, indB: int): Key =
  return (indA.Natural, indB.Natural)


func initSubsolutions(lenA, lenB: Natural): Table[Key, Natural] =
  for indA in 0.Natural..lenA:
    result[toKey(indA, 0)] = indA

  for indB in 1.Natural..lenB:
    result[toKey(0, indB)] = indB


func computeLevenshteinDistanceMatrix(a, b: string): Table[Key, Natural] =
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
      TestCase(strA: "", strB: "", distance: 0.Natural),
      TestCase(strA: "", strB: "a", distance: 1.Natural),
      TestCase(strA: "a", strB: "a", distance: 0.Natural),
      TestCase(strA: "a", strB: "ab", distance: 1.Natural),
      TestCase(strA: "saturday", strB: "sunday", distance: 3.Natural),
      TestCase(strA: "kitten", strB: "sitting", distance: 3.Natural),
      TestCase(strA: "abcdefghif", strB: "abCdeFghIfX", distance: 4.Natural),
      TestCase(strA: "abc", strB: "aXcY", distance: 2.Natural),
      ]

    test "returns expected result":
      for tc in testCases:
        check tc.distance == levenshteinDistance(tc.strA, tc.strB)

    test "is symmetric":
      for tc in testCases:
        check tc.distance == levenshteinDistance(tc.strB, tc.strA)
