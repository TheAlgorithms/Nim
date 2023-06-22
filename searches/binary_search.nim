## Binary Search
## =============
## Binary search is faster than linear search except for small arrays.
## However, the array must be sorted first to be able to apply binary search.
##
## Binary search compares an element in the middle of the array with the key value.
## If the key matches the middle element, its position in the array is returned.
## If the key is less than the middle element, we shift right boundary to the middle position.
## If the key is greater than the middle element, we shift left boundary to the middle position.
## By doing this, the algorithm eliminates the half in which the key value cannot lie in each iteration.
## https://en.wikipedia.org/wiki/Binary_search_algorithm
##
## Time Complexity: O(log n) where n is the length of the array.
{.push raises: [].}

runnableExamples:
  var arr1 = [0, 1, 2, 4, 5, 6]
  doAssert binarySearch(arr1, 5) == some(Natural(4))

  var arr2 = ['a', 'c', 'd', 'e', 'x', 'z']
  doAssert binarySearch(arr2, 'e') == some(Natural(3))

  var arr3 = [0, 1, 2, 3, 4]
  doAssert binarySearch(arr3, 7) == none(Natural)

import std/options

func binarySearch*[T:Ordinal](arr: openArray[T], key: T): Option[Natural] =
  ## Binary search can only be applied to sorted arrays.
  ## For this function array should be sorted in ascending order.
  var 
    left = arr.low
    right = arr.high

  while left <= right:
    let mid = left + (right - left) div 2

    if arr[mid] == key: 
      return some(mid.Natural)

    if key < arr[mid]: 
      right = mid - 1
    else:
      left = mid + 1

  # `none(Natural)` is returned when both halfs are empty after some iterations.
  return none(Natural)

when isMainModule:
  import unittest

  template checkBinarySearch[T:Ordinal](arr: openArray[T], key: T, expected: Option[Natural]): untyped =
    check binarySearch(arr, key) == expected

  suite "Binary Search": 
    test "search an empty array":
      var arr: array[0, int]
      checkBinarySearch(arr, 5, none(Natural))

    test "Search in an int array matching with a valid value":
      var arr = [0, 1, 2, 3, 5, 6]
      checkBinarySearch(arr, 5, some(Natural(4)))

    test "Search in an int array for a missing value":
      var arr = [0, 1, 2, 3, 5, 6]
      checkBinarySearch(arr, 4, none(Natural))

    test "Search in a char array with a matching value":
      var arr = ['0', '1', '2', '3', '5', 'a']
      checkBinarySearch(arr, '5', some(Natural(4)))

    test "Search in an array with a valid key at the end":
      var arr = [0, 1, 2, 3, 5, 6]
      checkBinarySearch(arr, 6, some(Natural(5)))

    test "Search in an even-length array with a valid key in the middle":
      var arr = [0, 1, 2, 3, 5, 6]
      checkBinarySearch(arr, 3, some(Natural(3)))

    test "Search in an odd-length array with a valid key in the middle":
      var arr = [0, 1, 2, 3, 5]
      checkBinarySearch(arr, 2, some(Natural(2)))
