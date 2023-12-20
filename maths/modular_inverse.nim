## Modular inverse

import std/[options, math]

import ./extended_gcd.nim


func euclidHalfIteration(inA, inB: Positive): (Natural, int) =
  var (a, b) = (inA.Natural, inB.Natural)
  var (x0, x1) = (1, 0)
  while b != 0:
    (x0, x1) = (x1, x0 - (a div b) * x1)
    (a, b) = (b, a mod b)

  (a, x0)


func modularInverse*(inA: int, modulus: Positive): Option[Positive] =
  ## For given integer `a` and a natural number `modulus` it
  ## computes the inverse of `a` modulo `modulus`, i.e.
  ## it finds an integer `0 < inv < modulus` such that
  ## `(a * inv) mod modulus == 1`.
  let a = math.floorMod(inA, modulus)
  if a == 0:
    return none(Positive)
  let (gcd, x) = euclidHalfIteration(a, modulus)
  if gcd == 1:
    return some(math.floorMod(x, modulus).Positive)
  none(Positive)


when isMainModule:
  import std/[unittest, sequtils, strformat]
  suite "modularInverse":
    const testCases = [
      (3, 7, 5),
      (-1, 5, 4),
      (4, 5, 4),
      (9, 5, 4),
      (5, 21, 17),
      (2, 21, 11),
      (4, 21, 16),
      (55, 372, 115),
      (1, 100, 1),
      ].mapIt:
        let tc = (id: fmt"a={it[0]}, modulus={it[1]}", a: it[0], modulus: it[1],
            inv: it[2])
        assert 0 < tc.inv
        assert tc.inv < tc.modulus
        assert math.floorMod(tc.a * tc.inv, tc.modulus) == 1
        tc

    for tc in testCases:
      test tc.id:
        checkpoint("returns expected result")
        check modularInverse(tc.a, tc.modulus).get() == tc.inv

    test "No inverse when modulus is 1":
      check modularInverse(0, 1).is_none()
      check modularInverse(1, 1).is_none()
      check modularInverse(-1, 1).is_none()

    test "No inverse when inputs are not co-prime":
      check modularInverse(2, 4).is_none()
      check modularInverse(-5, 25).is_none()
      check modularInverse(0, 17).is_none()
      check modularInverse(17, 17).is_none()
