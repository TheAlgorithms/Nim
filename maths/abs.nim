## Absolute value
{.push raises: [].}
import std/algorithm

runnableExamples:
  doAssert absVal(-5.1) == 5.1
  doAssert absMin(@[-1, 2, -3]) == 1
  doAssert absMax(@[-1, 2, -3]) == 3
  doAssert absMaxSort(@[3, -10, -2]) == -10

func absVal(num: float): float =
  ## Returns the absolute value of a number.
  return if num < 0.0: -num else: num

# Same for integers but return a Natural
func absVal(num: int): Natural = (if num < 0: -num else: num)

func absMin(x: seq[int]): Natural {.raises: [ValueError].} =
  ## Returns the smallest element in absolute value in a sequence.
  if x.len == 0:
    raise newException(ValueError, "Cannot find absolute minimum of an empty sequence")
  result = absVal(x[0])
  for i in 1 ..< x.len:
    if absVal(x[i]) < result:
      result = absVal(x[i])

func absMax(x: seq[int]): Natural {.raises: [ValueError].} =
  ## Returns the largest element in absolute value in a sequence.
  if x.len == 0:
    raise newException(ValueError, "Cannot find absolute maximum of an empty sequence")
  result = absVal(x[0])
  for i in 1 ..< x.len:
    if absVal(x[i]) > result:
      result = absVal(x[i])

func absMaxSort(x: seq[int]): int {.raises: [ValueError].} =
  ## Returns the signed element whose absolute value is the largest in a sequence.
  var x: seq[int] = x
  if x.len == 0:
    raise newException(ValueError, "Cannot find absolute maximum of an empty sequence")
  sort(x, proc (a, b: int): int = int(absVal(b)) - int(absVal(a)))
  return x[0]

when isMainModule:
  import std/[unittest, random]
  randomize()

  suite "Check `absVal`":
    test "Check `absVal`":
      check:
        absVal(11.2) == 11.2
        absVal(5) == 5
        absVal(-5.1) == 5.1
        absVal(-5) == abs_val(5)
        absVal(0) == 0

  suite "Check `absMin`":
    test "Check `absMin`":
      check:
        absMin(@[-1, 2, -3]) == 1
        absMin(@[0, 5, 1, 11]) == 0
        absMin(@[3, -10, -2]) == 2
    
    test "`absMin` on empty sequence raises ValueError":
      doAssertRaises(ValueError):
        discard absMin(@[])
  
  suite "Check `absMax`":
    test "Check `absMax`":
      check:
        absMax(@[0, 5, 1, 11]) == 11
        absMax(@[3, -10, -2]) == 10
        absMax(@[-1, 2, -3]) == 3
    
    test "`absMax` on empty sequence raises ValueError":
      doAssertRaises(ValueError):
        discard absMax(@[])
  
  suite "Check `absMaxSort`":
    test "Check `absMaxSort`":
      check:
        absMaxSort(@[3, -2, 1, -4, 5, -6]) == -6
        absMaxSort(@[0, 5, 1, 11]) == 11
    
    test "`absMaxSort` on empty sequence raises ValueError":
      doAssertRaises(ValueError):
        discard absMaxSort(@[])