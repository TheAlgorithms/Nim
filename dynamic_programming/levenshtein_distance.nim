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
  ## .. Note:: This is a basic suboptimal implementation with a O(a.len*b.len)
  ##    time complexity and O(a.len*b.len) additional memory usage.
  runnableExamples:
    doAssert levenshteinDistance("abc", "aXcY") == 2
  return computeLevenshteinDistanceMatrix(a, b)[toKey(a.len, b.len)]


when isMainModule:
  import std/unittest

  suite "levenshteinDistance":

    type
      TestCase = object
        name, a*, b*: string
        distance*: Natural

    func getTC(name, a, b: string, distance: int): TestCase =
      assert distance >= 0
      return TestCase(name: name, a: a, b: b, distance: distance)

    const testCases = @[
      getTC("two empty strings", "", "", 0),
      getTC("empty string vs. one char", "", "a", 1),
      getTC("two same strings", "b", "b", 0),
      getTC("one extra character", "a", "ab", 1),
      getTC("wiki-example 1", "saturday", "sunday", 3),
      getTC("wiki-example 2", "kitten", "sitting", 3),
      getTC("4 edits", "abcdefghif", "abCdeFghIfX", 4),
      getTC("2 edits", "abc", "aXcY", 2),
      ]

    test "returns expected result":
      for tc in testCases:
        check tc.distance == levenshteinDistance(tc.a, tc.b)

    test "is symmetric":
      for tc in testCases:
        check tc.distance == levenshteinDistance(tc.b, tc.a)
