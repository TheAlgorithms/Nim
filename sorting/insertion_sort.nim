## Insertion Sort Algorithm Implementation
##
## https://en.wikipedia.org/wiki/Insertion_sort
## Worst Time Complexity: O(n^2)
## Best Time Complexity: O(n)
## Worst Space Complexity: O(n)

## Import unit testing for testing purposes
import unittesting

proc insertion_sort()


## Test
test "Empty array":
  var arr: seq[int]
  insertion_sort(arr)
  echo repr(arr)
  check arr == []


test "one element array":
  var arr = @[1]
  insertion_sort(arr)
  echo repr(arr)
  check arr == [1]


test "complete array":
  var arr = @[5, 6, 2, 1, 3]
  insertion_sort(arr)
  echo repr(arr)
  check arr == @[1, 2, 3, 5, 6]
