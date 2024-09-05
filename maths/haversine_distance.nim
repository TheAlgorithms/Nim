# Haversine formula

import std/math

func haversineDistance(latitudeA, longitudeA, latitudeB,
    longitudeB: float): float =
  ## returns the length of the shortest path connecting the input points on an unit sphere.
  ## The input points are represented by their spherical/geographical coordinates.
  ## The inputs are expected to be in radians.
  let
    dLatitude = latitudeB - latitudeA
    dLongitude = longitudeB - longitudeA
    a = sin(dLatitude / 2.0)^2 + cos(latitudeA) * cos(latitudeB) * sin(
        dLongitude / 2.0)^2
  2.0 * arcsin(sqrt(a))

when isMainModule:
  import std/[unittest, sequtils, strformat]
  suite "haversineDistance":
    const testCases = [
      (0.0, 0.0, 0.0, 0.0, 0.0),
      (0.0, 0.0, PI / 2.0, 0.0, PI / 2.0),
      (-PI / 2.0, 0.0, PI / 2.0, 0.0, PI),
      (0.0, 0.0, 0.0, PI / 2.0, PI / 2.0),
      (0.0, -PI / 2.0, 0.0, PI / 2.0, PI),
      (1.0, -PI / 2.0, -1.0, PI / 2.0, PI),
      (2.0, -PI / 2.0, -2.0, PI / 2.0, PI),
      (3.0, -PI / 2.0, -3.0, PI / 2.0, PI),
      (3.0, -PI / 2.0 + 0.5, -3.0, PI / 2.0 + 0.5, PI),
      (0.0, 0.0, 0.0, PI, PI),
      (PI / 2.0, 1.0, PI / 2.0, 2.0, 0.0),
      (-PI / 2.0, 1.0, -PI / 2.0, 2.0, 0.0),
      (0.0, 0.0, -PI / 4.0, 0.0, PI / 4.0),
      (0.0, 1.0, PI / 4.0, 1.0, PI / 4.0),
      (-PI / 2.0, 0.0, -PI / 4.0, 0.0, PI / 4.0),
      (-PI / 2.0, 0.0, -PI / 4.0, 0.6, PI / 4.0),
      (-PI / 2.0, 3.0, -PI / 4.0, 0.2, PI / 4.0),
      ].mapIt:
        (id: fmt"posA=({it[0]}, {it[1]}), posB=({it[2]}, {it[3]})",
         latitudeA: it[0], longitudeA: it[1],
         latitudeB: it[2], longitudeB: it[3],
         expected: it[4])

    func isClose(a, b: float): bool =
      return abs(a-b) < 0.0000001

    for tc in testCases:
      test tc.id:
        checkpoint("returns expected result")
        check isClose(haversineDistance(tc.latitudeA, tc.longitudeA,
            tc.latitudeB, tc.longitudeB), tc.expected)
        check isClose(haversineDistance(tc.latitudeB, tc.longitudeB,
            tc.latitudeA, tc.longitudeA), tc.expected)
