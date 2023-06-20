## Linear Search
## =============
## Linear search is the simplest but least efficient algorithm
## to search for an element in a data set.
## It examines each element until it finds a match,
## starting at the beginning of the data set for the iterative version,
## or in the opposite direction for the recursive version, as implemented in this module.
## The search is finished and terminated once the target element is located.
## https://www.simplilearn.com/tutorials/data-structure-tutorial/linear-search-algorithm
##
## Time Complexity: O(N)
## Space Complexity in for-loop linear search: O(1)
## Space Complexity in recursive linear search: O(n)
## This is because of the call stack operation,
## and there is no CPS automatic optimization in Nim
## CPS: https://en.wikipedia.org/wiki/Continuation-passing_style

runnableExamples:
  var arr1 = [0, 3, 1, 4, 5, 6]
  doAssert linearSearch(arr1, 5) == some(Natural(4))
  doAssert recursiveLinearSearch(arr1, 5) == some(Natural(4))

  var arr2 = ['0', 'c', 'a', 'u', '5', '7']
  doAssert linearSearch(arr2, '5') == some(Natural(4))
  doAssert recursiveLinearSearch(arr2, '5') == some(Natural(4))


import std/options

type
  Nat = Natural
  OptNat = Option[Natural]

func linearSearch*[T](arr: openArray[T], key: T): OptNat = 
  # key is the value for matching in the array
  for i, val in arr.pairs():
    if val == key:
      return some(Natural(i))
  none(Natural) # `key` not found

func recursiveLinearSearch*[T](arr: openArray[T], key: T, idx: Nat = arr.low.Nat): OptNat=
  # Recursion is another method for linear search
  # we can just replace the for loop with recursion.

  # `none(Natural)` is returned when the array is traversed completely
  # and no key is matched, or when `arr` is empty and has a length of 0
  if idx >= arr.high:
    return none(Natural)
  if arr[idx] == key:
    return some(idx)
  recursiveLinearSearch(arr, key, idx + 1)


when isMainModule:
  import unittest

  template checkLinearSearch[T](arr: openArray[T], key: T, expectedIdx: OptNat =
    check linearSearch(arr, key) == expectedIdx
    check recursiveLinearSearch(arr, key) == expectedIdx

  suite "Linear search":
    test "Search in an empty array":
      var arr: array[0, int]

      checkLinearSearch(arr, 5, none(Natural))

    test "Search in an int array matching with a valid value":
      var arr = [0, 3, 1, 4, 5, 6]

      checkLinearSearch(arr, 5, some(Natural(4)))

    test "Search in an int array matching with an invalid value":
      var arr = [0, 3, 1, 4, 5, 6]

      checkLinearSearch(arr, 7, none(Natural))

    test "Search in a char array matching with a char matching value":
      var arr = ['0', 'c', 'a', 'u', '5', '7']

      checkLinearSearch(arr, '5', some(Natural(4)))

    test "Search in a string array matching with a string matching value":
      var arr = ["0", "c", "a", "u", "5", "7"]

      checkLinearSearch(arr, "5", some(Natural(4)))
