## Counting Sort
#[
Counting sort is an integer sorting algorithm. It sorts a collection of objects
according to their keys. It operates by counting the number of objects that possess distinct key values,
and applying prefix sum on those counts to determine the positions of each key value in the output sequence.
Its running time is linear in the number of items and the difference
between the maximum key value and the minimum key value
References:
https://en.wikipedia.org/wiki/Counting_sort
https://github.com/ringabout/data-structure-in-Nim/blob/master/countingSort.nim
]#

import std/tables

# proc countingSort*(x: openArray[int]): openArray[int] =
#   ## `aid` is a count table
#   let
#     length = x.len
#     smax = max(x)
#   var aid = newSeq(smax + 1)
#   result = newSeq(length)
#   # Make `aid` a count table of x
#   for i in 0 ..< length:
#     aid[x[i]] += 1

#   aid[0] -= 1
#   # `aid[i]` counts occurences of x[j] for all j <= i
#   for i in 1 .. smax:
#     aid[i] += aid[i-1]

#   for i in countdown(x.high, 0, 1):
#     result[aid[x[i]]] = x[i]
#     aid[x[i]] -= 1

# proc countingSortWithTable*[T](x: openArray[T]): openArray[T] =
#   var
#     length = x.len
#     smax = max(x)
#     frequenciesTable = toCountTable(x)
#   dec frequenciesTable[0]
#   for i in 1 .. smax:
#     frequenciesTable[i] += frequenciesTable[i-1]
#   result = newSeq[T](length)
#   for i in countdown(x.high, 0, 1):
#     result[frequenciesTable[x[i]]] = x[i]
#     frequenciesTable[x[i]] -= 1

func countingSort*[T: SomeInteger](x: seq[T]): seq[T] =
  ## https://github.com/ringabout/data-structure-in-Nim/blob/master/countingSort.nim
  ## `aid` is a count table
  let
    length = x.len
    smax = max(x)
  var aid = newSeq[T](smax + 1)
  result = newSeq[T](length)
  # Make `aid` a count table of x
  for i in 0 ..< length:
    aid[x[i]] += 1

  aid[0] -= 1
  # `aid[i]` counts occurences of x[j] for all j <= i
  for i in 1 .. smax:
    aid[i] += aid[i-1]

  for i in countdown(x.high, 0, 1):
    result[aid[x[i]]] = x[i]
    aid[x[i]] -= 1

when isMainModule:
  import std/[unittest, random]
  import ./testSort
  randomize()

  suite "Counting Sort":
    test "Integers":
      check testSort countingSort[int]
    # test "Float":
    #   check testSort countingSort[float]
    # test "Char":
    #   check testSort countingSortWithTable[char]
