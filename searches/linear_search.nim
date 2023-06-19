## Linear Search
## =============
#[
Linear search is the simplest but least efficient algorithm
to search for an element in a data set.
It examines each element until it finds a match,
starting at the beginning of the data set, until the end.
The search is finished and terminated once the target element is located.
# https://www.simplilearn.com/tutorials/data-structure-tutorial/linear-search-algorithm
]#
## Time Complexity: O(N)
## Space Complexity in for-loop linear search: O(1)
## Space Complexity in recursive linear search: O(n)
## This is because of the call stack operation,
## and there is no CPS automatic optimization in Nim
## CPS: https://en.wikipedia.org/wiki/Continuation-passing_style

# openArray[T] is a func parameter type that accept arrays and seqs in any type
# value is the value for matching in the array
func linearSearch[T](arr: openArray[T], value: T): int = 
  for i in arr.low .. arr.high:
    if arr[i] == value:
      return i
  return -1 # -1 is the default index for unfound element

## Recursion is another method for linear search
## we can just replace the for loop with recursion.
## recursion traverses from the end of the array to the front.
func recursiveLinearSearch[T](arr: openArray[T], idx: int, value: T): int =
  ## return -1 would be invoked when the array is traversed completely
  ## and no value is matched, or when array is empty and has a length of 0
  if idx == -1:
    return -1
  if arr[idx] == value:
    return idx
  return recursiveLinearSearch(arr, idx - 1, value)

when isMainModule:
  import unittest

  suite "Linear search":
    test "Search in an empty array":
      var arr: array[0, int]

      check linearSearch(arr, 5) == -1
      check recursiveLinearSearch(arr, arr.len - 1, 5) == -1

    test "Search in an int array matching with a valid value":
      var arr = @[0, 3, 1, 4, 5, 6]

      check linearSearch(arr, 5) == 4
      check recursiveLinearSearch(arr, arr.len - 1, 5) == 4

    test "Search in an int array matching with an invalid value":
      var arr = @[0, 3, 1, 4, 5, 6]

      check linearSearch(arr, 7) == -1
      check recursiveLinearSearch(arr, arr.len - 1, 7) == -1

    test "Search in a char array matching with a char matching value":
      var arr = @['0', 'c', 'a', 'u', '5', '7']

      check linearSearch(arr, '5') == 4
      check recursiveLinearSearch(arr, arr.len - 1, '5') == 4

    test "Search in a string array matching with a string matching value":
      var arr = @["0", "c", "a", "u", "5", "7"]

      check linearSearch(arr, "5") == 4
      check recursiveLinearSearch(arr, arr.len - 1, "5") == 4