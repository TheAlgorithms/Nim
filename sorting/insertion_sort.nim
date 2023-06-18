## Insertion Sort Algorithm Implementation
##
## https://en.wikipedia.org/wiki/Insertion_sort
## Worst Case Time Complexity: O(n^2)
## Best Case Time Complexity: O(n)
## Worst Case Space Complexity: O(n)

## Import unit testing for testing purposes
import unittest

## Define the function
proc insertion_sort(arr: var openarray[int]) =

  ## Length is the length of arr
  var length = high(arr)

  if length <= 1:
    ## If length is or is less than one, no execution
    return

  ## Iterate through array
  for i in 1..high(arr):

    ## You can treat "key" as a temporary variable
    var key = arr[i]

    ##  Move elements of arr[0..i-1], that are
    ##  greater than key, to one position ahead
    ##  of their current position
    var j = i - 1
    while j >= 0 and key < arr[j] :
      arr[j + 1] = arr[j]
      j -= 1
    arr[j + 1] = key

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
