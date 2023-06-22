## Binary Search
## =============
## Binary search is an efficient searching algorithm. It is faster than linear 
## search except for small arrays. However, binary search can only be used on sorted arrays.
## If the array is not sorted, it must be sorted first before binary search can be applied.
##
## Binary search starts by comparing the key value with the middle element of the array.
## If the key value matches the middle element, the search is complete.
## If the key value is less than the middle element, the search continues on the lower half of the array.
## If the key value is greater than the middle element, the search continues on the upper half of the array.
## This process repeats until the middle element matches the key value or the search space is exhausted.
## https://en.wikipedia.org/wiki/Binary_search_algorithm
##
## Time Complexity: O(log n), where n is the length of the array.
## Space Complexity in iterative approach: O(1)
## Space Complexity in recursive approach: O(n)
{.push raises: [].}

runnableExamples:
  import std/options

  var arr1 = [0, 1, 2, 4, 5, 6]
  doAssert binarySearchIterative(arr1, 5) == some(Natural(4))

  var arr2 = ['a', 'c', 'd', 'e', 'x', 'z']
  doAssert binarySearchIterative(arr2, 'e') == some(Natural(3))

  var arr3 = [0, 1, 2, 3, 4]
  doAssert binarySearchIterative(arr3, 7) == none(Natural)

import std/options

func binarySearchIterative*[T:Ordinal](arr: openArray[T], key: T): Option[Natural] =
  ## Binary search can only be applied to sorted arrays.
  ## For this function array should be sorted in ascending order.
  var 
    left = arr.low
    right = arr.high

  while left <= right:
    let mid = left + (right - left) div 2

    if arr[mid] == key: 
      return some(Natural(mid))

    if key < arr[mid]: 
      right = mid - 1
    else:
      left = mid + 1
  # `none(Natural)` is returned when both halves are empty after some iterations.
  none(Natural)

func binarySearchRecursive[T:Ordinal](arr: openArray[T], left, right: int, key: T): Option[Natural] =
  if left <= right:
    let mid = left + (right - left) div 2

    return
      if arr[mid] == key: 
        some(Natural(mid))
      elif key < arr[mid]: 
        binarySearchRecursive(arr, left, mid - 1, key)
      else:
        binarySearchRecursive(arr, mid + 1, right, key)
  none(Natural)

func binarySearchRecursive*[T:Ordinal](arr: openArray[T], key: T): Option[Natural] =
  ## Recursive implementation of binary search for an array sorted in ascending order
  binarySearchRecursive(arr, 0, arr.high(), key)

when isMainModule:
  import unittest

  const
    empty: array[0, int] = []
    arr = [0, 1, 2, 3, 5, 6]
    odd = [0, 1, 2, 3, 5]
    chars = ['0', '1', '2', '3', '5', 'a']

  template checkBinarySearch[T:Ordinal](arr: openArray[T], key: T, expected: Option[Natural]): untyped =
    check binarySearchIterative(arr, key) == expected
    check binarySearchRecursive(arr, key) == expected

  suite "Binary Search": 
    test "Empty array":
      checkBinarySearch(empty, 5, none(Natural))
    test "Matching value in an int array":
      checkBinarySearch(arr, 5, some(Natural(4)))
    test "Missing value":
      checkBinarySearch(arr, 4, none(Natural))
    test "Matching value in a char array":
      checkBinarySearch(chars, '5', some(Natural(4)))
    test "Matching key at the start":
      checkBinarySearch(arr, 0, some(Natural(0)))
    test "Matching key at the end":
      checkBinarySearch(arr, 6, some(Natural(5)))
    test "Even-length array with a matching key in the middle":
      checkBinarySearch(arr, 3, some(Natural(3)))
    test "Odd-length array with a matching key in the middle":
      checkBinarySearch(odd, 2, some(Natural(2)))
