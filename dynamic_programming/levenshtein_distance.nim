## Levenshtein distance
##
## [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)
## is an example of
## [edit distance](https://en.wikipedia.org/wiki/Edit_distance).

import tables

type Key = (Natural, Natural)


func toKey(indA, indB: int): Key =
  return (indA.Natural, indB.Natural)


func initLevenshteinDistanceMatrix(lenA, lenB: Natural): Table[Key, Natural] =
  # Partially init the distance matrix:
  # - Pre-fill with distances between all prefixes of `a` and an empty string
  for indA in 0.Natural..lenA:
    result[toKey(indA, 0)] = indA

  # - Pre-fill with distances between an empty string and all prefixes of `b`
  for indB in 1.Natural..lenB:
    result[toKey(0, indB)] = indB


proc fillLevenshteinDistanceMatrix(
    distances: var Table[Key, Natural],
    a, b: string) =
  ## `distances[toKey(posA, posB)]` is the Levenshtein distance between
  ## prefix of `a` with length `posA` and prefix of `b` with length `posB`
  for indA in 0..<a.len:
    for indB in 0..<b.len:
      let
        ## from the perspective of changing `a` into `b`
        distanceIfDeleted = distances[toKey(indA, indB + 1)] + 1
        distanceIfInserted = distances[toKey(indA + 1, indB)] + 1
        substitutionCost = (if a[indA] == b[indB]: 0 else: 1)
        distanceIfSubstituted = distances[toKey(indA, indB)] + substitutionCost
      distances[toKey(indA + 1, indB + 1)] = min(
          [distanceIfDeleted, distanceIfInserted, distanceIfSubstituted])


func computeLevenshteinDistanceMatrix(a, b: string): Table[Key, Natural] =
  result = initLevenshteinDistanceMatrix(a.len, b.len)
  fillLevenshteinDistanceMatrix(result, a, b)


func levenshteinDistance*(a, b: string): Natural =
  ## Returns the
  ## [Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)
  ## between the input strings.
  ## This is a basic suboptimal implementation with
  ## a `O(a.len*b.len)` time complexity
  ## and `O(a.len*b.len)` additional memory usage.
  ## It is based on
  ## [Wagner–Fischer algorithm](https://en.wikipedia.org/wiki/Wagner%E2%80%93Fischer_algorithm).
  runnableExamples:
    doAssert levenshteinDistance("abc", "aXcY") == 2
  return computeLevenshteinDistanceMatrix(a, b)[toKey(a.len, b.len)]


when isMainModule:
  import std/[unittest, sequtils]
  suite "levenshteinDistance":
    const testCases = [
      ("two empty strings", "", "", 0),
      ("empty string vs. one char", "", "a", 1),
      ("two same strings", "b", "b", 0),
      ("one extra character", "a", "ab", 1),
      ("wiki-example 1", "saturday", "sunday", 3),
      ("wiki-example 2", "kitten", "sitting", 3),
      ("4 edits", "abcdefghif", "abCdeFghIfX", 4),
      ("2 edits", "abc", "aXcY", 2),
      ].mapIt:
        assert it[3] >= 0
        (name: it[0], a: it[1], b: it[2], distance: it[3].Natural)

    for tc in testCases:
      test tc.name:
        checkpoint("returns expected result")
        check levenshteinDistance(tc.a, tc.b) == tc.distance
        checkpoint("is symmetric")
        check levenshteinDistance(tc.b, tc.a) == tc.distance
