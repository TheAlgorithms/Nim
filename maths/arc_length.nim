## Arc Length
## https://en.wikipedia.org/wiki/Arc_length
import std/math
{.push raises: [].}

func arcLengthDegree(radius: float, angle: float): float =
  ## Calculate the length of an arc given the `radius` and `angle` in degrees.
  return PI * radius * (angle / 180)

func arcLengthRadian(radius: float, angle: float): float =
  ## Calculate the length of an arc given the `radius` and `angle` in radians.
  return radius * angle

when isMainModule:
  import std/unittest
  const UnitsInLastPlace = 1
  suite "Arc Length":
    test "radius 5, angle 45":
      check almostEqual(arcLengthDegree(5, 45), 3.926990816987241, UnitsInLastPlace)
    test "radius 15, angle 120":
      check almostEqual(arcLengthDegree(15, 120), 31.41592653589793, UnitsInLastPlace)
    test "radius 10, angle 90":
      check almostEqual(arcLengthDegree(10, 90), 15.70796326794897, UnitsInLastPlace)

  suite "Arc Length":
    test "radius 5, angle 45":
      check almostEqual(arcLengthRadian(5, degToRad(45.0)), 3.926990816987241,
       UnitsInLastPlace)
    test "radius 15, angle 120":
      check almostEqual(arcLengthRadian(15, degToRad(120.0)), 31.41592653589793,
       UnitsInLastPlace)
    test "radius 10, angle 90":
      check almostEqual(arcLengthRadian(10, degToRad(90.0)), 15.70796326794897,
       UnitsInLastPlace)
