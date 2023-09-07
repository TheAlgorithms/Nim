## Linear Search
## =============
## Linear search is the simplest but least efficient searching algorithm
## to search for an element in an array.
## It examines each element until it finds a match,
## starting at the beginning of the data set toward the end.
## The search ends when the element is located or when the end of the array is reached.
## https://en.wikipedia.org/wiki/Linear_search
##
## Time Complexity: O(n) where n is the length of the array.
## Space Complexity in for-loop linear search: O(1)
## Space Complexity in recursive linear search: O(n)
## Notice that recursive algorithms are nice to write and provide elegant implementations,
## but they are impeded by call stack management. Whatever the problem we face,
## there will be as much memory requirement as the number of stack frames.
## Therefore the recursive linear search is less efficient than the for-loop-based one.

runnableExamples:
  import std/options

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

func linearSearch*[T](arr: openArray[T], key: T): Option[Natural] =
  ## Searches for the `key` in the array `arr` and returns its absolute index (counting from 0)
  ## in the array.
  ## .. Note:: For arrays indexed with a range type or an enum the returned value
  ##  may not be consistent with the indexing of the initial array.
  for i, val in arr.pairs():
    if val == key:
      return some(Natural(i))
  none(Natural) # `key` not found

func recursiveLinearSearch*[T](
  arr: openArray[T], key: T, idx: Natural = Natural(0)): Option[Natural] =
  ## Searches for the `key` in `arr` and returns its absolute index (counting from 0)
  ## in the array. Search is performed in a recursive manner.
  ## .. Note:: For arrays indexed with a range type or an enum the returned value
  ##  is not consistent with the indexing of the parameter array if `arr.low` is not 0.
  # Recursive calls replace the `for` loop in `linearSearch`.

  # `none(Natural)` is returned when the array is traversed completely
  # and no key is matched, or when `arr` is empty.
  if idx > arr.high:
    return none(Natural)
  if arr[idx] == key:
    return some(idx)
  recursiveLinearSearch(arr, key, idx + 1)


when isMainModule:
  import unittest

  template checkLinearSearch[T](arr: openArray[T], key: T,
      expectedIdx: Option[Natural]): untyped =
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

    test "Search in a string sequence matching with a string matching value":
      var arr = @["0", "c", "a", "u", "5", "7"]
      checkLinearSearch(arr, "5", some(Natural(4)))

    test "Search in an int array with a valid key at the end":
      var arr = [1, 5, 3, 6, 5, 7]
      checkLinearSearch(arr, 7, some(Natural(5)))
