## Levenshtein distance

import tables


func initSubsolutions(lenA: Natural, lenB: Natural): Table[(Natural, Natural), Natural] =
  for indA in 0..lenA:
    result[(Natural(indA), Natural(0))] = Natural(indA)

  for indB in 1..lenB:
    result[(Natural(0), Natural(indB))] = Natural(indB)


func toKey(indA: int, indB: int): (Natural, Natural) =
  return (Natural(indA), Natural(indB))


func computeLevenshteinDistanceMatrix(strA: string, strB: string): Table[(
    Natural, Natural), Natural] =
  let
    lenA = strA.len
    lenB = strB.len

  result = initSubsolutions(lenA, lenB)

  for indA in 1..lenA:
    for indB in 1..lenB:
      let substitutionCost = (if strA[indA-1] == strB[indB-1]: 0 else: 1)
      result[toKey(indA, indB)] = min(
          [result[toKey(indA-1, indB)] + 1,
           result[toKey(indA, indB-1)] + 1,
           result[toKey(indA-1, indB-1)] + substitutionCost])


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
