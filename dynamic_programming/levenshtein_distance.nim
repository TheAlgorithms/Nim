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
      let
        substitutionCost = (if a[indA] == b[indB]: 0 else: 1)
        distanceIfDeleted = result[toKey(indA, indB + 1)] + 1
        distanceIfInserted = result[toKey(indA + 1, indB)] + 1
        distanceIfSubstituted = result[toKey(indA, indB)] + substitutionCost
      result[toKey(indA + 1, indB + 1)] = min(
          [distanceIfDeleted,
           distanceIfInserted,
           distanceIfSubstituted])


func levenshteinDistance*(a, b: string): Natural =
  ## Returns the
  ## [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)
  ## between the input strings.
  ## This implementation utilises dynamic programming.
  ## Note that this implementation has O(a.len*b.len) time complexity and
  ## requires O(a.len*b.len) additional memory
  runnableExamples:
    doAssert levenshteinDistance("abc", "aXcY") == 2
  return computeLevenshteinDistanceMatrix(a, b)[toKey(a.len, b.len)]


when isMainModule:
  import std/unittest

  suite "levenshteinDistance":

    type
      TestCase = object
        a*, b*: string
        distance*: Natural

    const testCases = @[
      TestCase(a: "", b: "", distance: 0.Natural),
      TestCase(a: "", b: "a", distance: 1.Natural),
      TestCase(a: "a", b: "a", distance: 0.Natural),
      TestCase(a: "a", b: "ab", distance: 1.Natural),
      TestCase(a: "saturday", b: "sunday", distance: 3.Natural),
      TestCase(a: "kitten", b: "sitting", distance: 3.Natural),
      TestCase(a: "abcdefghif", b: "abCdeFghIfX", distance: 4.Natural),
      TestCase(a: "abc", b: "aXcY", distance: 2.Natural),
      ]

    test "returns expected result":
      for tc in testCases:
        check tc.distance == levenshteinDistance(tc.a, tc.b)

    test "is symmetric":
      for tc in testCases:
        check tc.distance == levenshteinDistance(tc.b, tc.a)
