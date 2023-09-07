## Absolute value
{.push raises: [].}
import std/strutils

runnableExamples:
  assert absVal(-5.1) == 5.1
  assert absMin(@[-1, 2, -3]) == 1
  assert absMax(@[-1, 2, -3]) == 3
  assert signedMinAbs(@[3, -10, -2]) == -2
  assert signedMaxAbs(@[3, -10, -2]) == -10

func absVal*[T: SomeFloat](num: T): T =
  ## Returns the absolute value of a number.
  ## Use `math.abs <https://nim-lang.org/docs/system.html#abs%2CT>`_ instead!
  return if num < 0.0: -num else: num

# Same for Integers but returns a Natural
func absVal*[T: SomeInteger](num: T): Natural = (if num < 0: -num else: num)

func absMin*(x: openArray[int]): Natural {.raises: [ValueError].} =
  ## Returns the smallest element in absolute value in a sequence.
  if x.len == 0:
    raise newException(ValueError, """Cannot find absolute minimum
     of an empty sequence""".unindent)
  result = absVal(x[0])
  for i in 1 ..< x.len:
    if absVal(x[i]) < result:
      result = absVal(x[i])

func absMax*(x: openArray[int]): Natural {.raises: [ValueError].} =
  ## Returns the largest element in absolute value in a sequence.
  if x.len == 0:
    raise newException(ValueError, """Cannot find absolute maximum of an empty
   sequence""".unindent)
  result = absVal(x[0])
  for i in 1 ..< x.len:
    if absVal(x[i]) > result:
      result = absVal(x[i])

func signedMinAbs*(x: openArray[int]): int {.raises: [ValueError].} =
  ## Returns the first signed element whose absolute value
  ## is the smallest in a sequence.
  if x.len == 0:
    raise newException(ValueError, """Cannot find absolute maximum of an empty
   sequence""".unindent)
  var (min, minAbs) = (x[0], absVal(x[0]))
  for n in x:
    let nAbs = absVal(n)
    if nAbs < minAbs: (min, minAbs) = (n, nAbs)
  min

func signedMaxAbs*(x: openArray[int]): int {.raises: [ValueError].} =
  ## Returns the first signed element whose absolute value
  ## is the largest in a sequence.
  if x.len == 0:
    raise newException(ValueError, """Cannot find absolute maximum of an empty
   sequence""".unindent)
  var (max, maxAbs) = (x[0], absVal(x[0]))
  for n in x:
    let nAbs = absVal(n)
    if nAbs > maxAbs: (max, maxAbs) = (n, nAbs)
  max

when isMainModule:
  import std/[unittest, random]
  randomize()

  suite "Check absVal":
    test "Check absVal":
      check:
        absVal(11.2) == 11.2
        absVal(5) == 5
        absVal(-5.1) == 5.1
        absVal(-5) == absVal(5)
        absVal(0) == 0

  suite "Check absMin":
    test "Check absMin":
      check:
        absMin(@[-1, 2, -3]) == 1
        absMin(@[0, 5, 1, 11]) == 0
        absMin(@[3, -10, -2]) == 2
        absMin([-1, 2, -3]) == 1
        absMin([0, 5, 1, 11]) == 0
        absMin([3, -10, -2]) == 2

    test "absMin on empty sequence raises ValueError":
      doAssertRaises(ValueError):
        discard absMin(@[])

  suite "Check absMax":
    test "Check absMax":
      check:
        absMax(@[0, 5, 1, 11]) == 11
        absMax(@[3, -10, -2]) == 10
        absMax(@[-1, 2, -3]) == 3

    test "`absMax` on empty sequence raises ValueError":
      doAssertRaises(ValueError):
        discard absMax(@[])

  suite "Check signedMinAbs":
    test "Check signedMinAbs":
      check:
        signedMinAbs(@[0, 5, 1, 11]) == 0
        signedMinAbs(@[3, -2, 1, -4, 5, -6]) == 1
        signedMinAbs(@[3, -2, -1, -4, 5, -6]) == -1

    test "Among two minimal elements, the first one is returned":
      check signedMinAbs(@[3, -2, 1, -4, 5, -6, -1]) == 1

  suite "Check signedMaxAbs":
    test "Check signedMaxAbs":
      check:
        signedMaxAbs(@[3, -2, 1, -4, 5, -6]) == -6
        signedMaxAbs(@[0, 5, 1, 11]) == 11

    test "signedMaxAbs on empty sequence raises ValueError":
      doAssertRaises(ValueError):
        discard signedMaxAbs(@[])
