## Extended Euclidean algorithm
##
## [Extended Euclidean algorithm](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm)

import std/math


func updateCoefficients(t0, t1, q: int): (int, int) =
  (t1, t0 - q * t1)


func euclidIteration(inA, inB: int): (int, int, int) =
  assert inA >= 0 and inB >= 0
  var (a, b) = (inA, inB)
  var (x0, x1) = (1, 0)
  var (y0, y1) = (0, 1)
  while b != 0:
    let q = a div b
    (x0, x1) = updateCoefficients(x0, x1, q)
    (y0, y1) = updateCoefficients(y0, y1, q)
    (a, b) = (b, a mod b)

  (a, x0, y0)


func extendedGCD*(a, b: int): (int, int, int) =
  ## Implements the
  ## [Extended Euclidean algorithm](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm).
  ## For given integers `a`, `b` it
  ## computes their [`gcd`](https://en.wikipedia.org/wiki/Greatest_common_divisor)
  ## and integers `x` and `y`, such that
  ## `gcd = a * x + b * y`
  let (gcd, x, y) = euclidIteration(abs(a), abs(b))
  return (gcd, math.sgn(a) * x, math.sgn(b) * y)


when isMainModule:
  import std/[unittest, sequtils]
  import std/strformat
  suite "extendedGCD":
    const testCases = [
      (10, 15, 5, -1, 1),
      (-10, -15, 5, 1, -1),
      (32, 64, 32, 1, 0),
      (0, 0, 0, 0, 0),
      (7, 0, 7, 1, 0),
      (-8, 0, 8, -1, 0),
      (48, 60, 12, -1, 1),
      (98, 56, 14, -1, 2),
      (10, -15, 5, -1, -1),
      (997, 12345, 1, -3467, 280),
      (997, 1234567, 1, -456926, 369),
      ].mapIt:
        let tc = (id: fmt"a={it[0]}, b={it[1]}", a: it[0], b: it[1],
            gcd: it[2], x: it[3], y: it[4])
        if tc.gcd != 0:
          assert tc.a mod tc.gcd == 0
          assert tc.b mod tc.gcd == 0
        else:
          assert tc.a == 0 and tc.b == 0
        assert tc.gcd == tc.a * tc.x + tc.b * tc.y
        tc

    for tc in testCases:
      test tc.id:
        checkpoint("returns expected result")
        check extendedGCD(tc.a, tc.b) == (tc.gcd, tc.x, tc.y)
        checkpoint("returns expected result when first argument negated")
        check extendedGCD(-tc.a, tc.b) == (tc.gcd, -tc.x, tc.y)
        checkpoint("returns expected result when second argument negated")
        check extendedGCD(tc.a, -tc.b) == (tc.gcd, tc.x, -tc.y)
        checkpoint("returns expected result when both arguments negated")
        check extendedGCD(-tc.a, -tc.b) == (tc.gcd, -tc.x, -tc.y)
        checkpoint("is symmetric")
        check extendedGCD(tc.b, tc.a) == (tc.gcd, tc.y, tc.x)
