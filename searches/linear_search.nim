## Linear Search
## =============
## Linear search is the simplest but least efficient searching algorithm
## to search for an element in a data set.
## It examines each element until it finds a match,
## starting at the beginning of the data set toward the end.
## The search ends when the element is located or when the end of the array is reached.
## https://en.wikipedia.org/wiki/Linear_search
##
## Time Complexity: O(n)
## Space Complexity in for-loop linear search: O(1)
## Space Complexity in recursive linear search: O(n)
## Notice that recursive algorithms are nice to write and provide elegant implementations,
## but they are impeded by call stack management. Whatever the problem we face,
## there will be as much memory requirement as the number of stack frames.
## Therefore the recursive linear search is less efficient than the for-loop-based one.

runnableExamples:
  var arr1 = [0, 3, 1, 4, 5, 6]
  doAssert linearSearch(arr1, 5) == some(Natural(4))
  doAssert recursiveLinearSearch(arr1, 5) == some(Natural(4))

  var arr2 = ['0', 'c', 'a', 'u', '5', '7']
  doAssert linearSearch(arr2, '5') == some(Natural(4))
  doAssert recursiveLinearSearch(arr2, '5') == some(Natural(4))

  var arr3 = [0, 3, 1, 4, 5, 6]
  doAssert linearSearch(arr3, 7) == none(Natural)
  doAssert recursiveLinearSearch(arr3, 7) == none(Natural)


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
  if idx > arr.high:
    return none(Natural)
  if arr[idx] == key:
    return some(idx)
  recursiveLinearSearch(arr, key, idx + 1)


when isMainModule:
  import unittest

  template checkLinearSearch[T](arr: openArray[T], key: T, expectedIdx: OptNat): untyped =
    check linearSearch(arr, key) == expectedIdx
    check recursiveLinearSearch(arr, key) == expectedIdx

  suite "Linear search":
    test "Search in an empty array":
      var arr: array[0, int]
      checkLinearSearch(arr, 5, none(Natural))

    test "Search in an int array matching with a valid value":
      var arr = [0, 3, 1, 4, 5, 6]
      checkLinearSearch(arr, 5, some(Natural(4)))

    test "Search in an int array for a missing value":
      var arr = [0, 3, 1, 4, 5, 6]
      checkLinearSearch(arr, 7, none(Natural))

    test "Search in a char array matching with a char matching value":
      var arr = ['0', 'c', 'a', 'u', '5', '7']
      checkLinearSearch(arr, '5', some(Natural(4)))

    test "Search in a string array matching with a string matching value":
      var arr = ["0", "c", "a", "u", "5", "7"]
      checkLinearSearch(arr, "5", some(Natural(4)))

    test "Search in an int array with a valid key at the end":
      var arr = [1, 5, 3, 6, 5, 7]
      checkLinearSearch(arr, 7, some(Natural(5)))
