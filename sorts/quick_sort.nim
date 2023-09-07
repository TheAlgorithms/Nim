## Quick Sort
##
## The Quick Sort is the first sort algorithm with a complexity less than quadratic
## and even reaching the optimal theoretical bound of a sorting algorithm.
##
## As a strategy, it selects an element (the pivot) which serves as
## a separation barrier. We put all elements higher than the pivot to its right,
## and all elements lower than the pivot to its left.
## We can operate recursively on the lists on each side. The base cases are lists
## of one or two elements (elements on the left and the right of the pivot are
## trivially sorted).
##
## complexity: O(n*log(n))
## https://en.wikipedia.org/wiki/Quicksort
## https://github.com/ringabout/data-structure-in-Nim/blob/master/sortingAlgorithms/quickSort.nim
{.push raises: [].}

import std/random

proc quickSort[T](list: var openArray[T], lo: int, hi: int) =
  ## Quick Sort chooses a pivot element against which other
  ## elements will be compared
  if lo >= hi:
    return
  # Pivot selection
  # Historically, developers used the first element as pivot
  # let pivot = lo
  # The best choice is to select at random the pivot!
  let pivot = rand(lo..hi)
  var
    i = lo + 1
    j = hi

  # We place temporarily the pivot element at the
  # lowest position
  swap(list[lo], list[pivot])
  var running = true

  # We do not know in advance the number of swaps to do
  while running:
    # Starting from the left, we select the first element that is superior to the pivot and ...
    while list[i] <= list[lo] and i < hi:
      i += 1
    # starting from the right, the first element that is inferior to the pivot.
    while list[j] >= list[lo] and j > lo:
      j -= 1
    # We swap them if they are not in increasing order
    if i < j:
      swap(list[i], list[j])
    # If no swaps have been done, all elements are positioned correctly
    # compared to the pivot, so we can exit the loop
    # If the pivot is the maximum then i=hi(=j) so we do not swap and
    # end the loop directly.
    else:
      running = false
    # If all elements are strictly superior to the pivot (i=lo+1, j=lo)(we selected the minimum!), we make two pass, one swapping the second element with the pivot, and one placing the pivot at the beginning again.
  # The pivot element is actually the (j − lo + 1)-th smallest element of the sublist, since we found (i − lo) = (j - lo + 1) elements smaller than it, and all other elements are larger.
  swap(list[lo], list[j])

  # Recursive calls - the whole list is sorted if and only if
  # both the upper and lower parts are sorted.
  quicksort(list, lo, j - 1)
  quicksort(list, j + 1, hi)


proc quickSort*[T](list: var openArray[T]) =
  ## Main function of the first quick sort implementation
  quicksort(list, list.low, list.high)


proc QuickSort[T](list: openArray[T]): seq[T] =
  ## Second quick sort implementation, out-of-place, making a lot of copies
  if len(list) == 0:
      return @[]
  # We select the first element for simplicity
  var pivot = list[0]
  # We explicitely create the left and right lists.

  # We can not guess the length in advance, so we have to use
  # a container on the heap.
  var left: seq[T] = @[]
  var right: seq[T] = @[]

  # If elements have the same value as the pivot, they are omitted!
  for i in low(list)..high(list):
      if list[i] < pivot:
          left.add(list[i])
      elif list[i] > pivot:
          right.add(list[i])

  # We concatenate the results
  result = QuickSort(left) &
    pivot &
    QuickSort(right)

when isMainModule:
  import std/[unittest]
  import test_sorts
  randomize()

  suite "Quick Sort":
    test "Integers":
      check testSort quickSort[int]
    test "Float":
      check testSort quickSort[float]
    test "Char":
      check testSort quickSort[char]
