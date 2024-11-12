## Bogo Sort
## =============
## wiki: https://en.wikipedia.org/wiki/Bogosort
##
{.push raises: [].}

runnableExamples:

  var arr = @[3, 1, 2]
  bogoSort(arr)
  doAssert isSorted(arr)

  var arr2 = @["c", "a", "b"]
  bogoSort(arr2)
  doAssert isSorted(arr2)


import random

func isSorted[T](arr: openArray[T]): bool =
  for i in 0..<arr.len - 1:
    if arr[i] > arr[i + 1]:
      return false
  return true

proc bogoSort*[T](arr: var openArray[T]) =
  while not isSorted(arr):
    shuffle(arr)

when isMainModule:
  import std/unittest
  suite "BogoSortTests":
    test "sort an array of integers":
      var arr = @[3, 1, 2]
      bogoSort(arr)
      check isSorted(arr)

    test "sort an array of strings":
      var arr = @["c", "a", "b"]
      bogoSort(arr)
      check isSorted(arr)
