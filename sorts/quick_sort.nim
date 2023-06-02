## Quick Sort
## Add Description
## TODO: Need an out of place version of the test
## https://en.wikipedia.org/wiki/Shellsort
## https://github.com/ringabout/data-structure-in-Nim/blob/master/sortingAlgorithms/quickSort.nim
{.push raises: [].}

import std/random

proc quickSort[T](list: var openArray[T], lo: int, hi: int) =
  ## Quick Sort chooses a pivot element against which other
  ## elements will be compared
  if lo >= hi:
    return
  # Pivot selection
  # Historically, the first element
  # let pivot = lo
  # More performant: choose at random!!!
  let pivot = rand(lo..hi)
  var
    i = lo + 1
    j = hi

  # We place the pivot element at the
  # lowest position
  swap(list[lo], list[pivot])
  var running = true
  while running:
    while list[i] <= list[lo] and i < hi:
      i += 1
    while list[j] >= list[lo] and j > lo:
      j -= 1
    if i < j:
      swap(list[i], list[j])
    else:
      running = false
  swap(list[lo], list[j])

  # Recursive calls
  quicksort(list, lo, j - 1)
  quicksort(list, j + 1, hi)


proc quickSort*[T](list: var openArray[T]) =
  ## Main function
  quicksort(list, list.low, list.high)


proc QuickSort[T](list: openArray[T]): seq[T] =
  ## Second quick sort implementation, out-of-place but making a lot of copies
  ## Easier to memorize
  if len(list) == 0:
      return @[]
  var pivot = list[0]
  var left: seq[T] = @[]
  var right: seq[T] = @[]
  for i in low(list)..high(list):
      if list[i] < pivot:
          left.add(list[i])
      elif list[i] > pivot:
          right.add(list[i])
  result = QuickSort(left) &
    pivot &
    QuickSort(right)

when isMainModule:
  import std/[unittest]
  import ./testSort
  randomize()

  suite "Quick Sort":
    test "Integers":
      check testSort quickSort[int]
      # check testSort QuickSort[int]
    test "Float":
      check testSort quickSort[float]
    test "Char":
      check testSort quickSort[char]
