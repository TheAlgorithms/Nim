## Insertion Sort
#[
This algorithm sorts a collection by comparing adjacent elements.
When it finds that order is not respected, it moves the element compared
backward until the order is correct.  It then goes back directly to the
element's initial position resuming forward comparison.

https://en.wikipedia.org/wiki/Insertion_sort
]#

import std/[random, sequtils, algorithm]

func insertionSortAllSwaps[T](l: var openArray[T]) =
  ## First implementation swaps elements until the right position is found
  var i = 1
  while i < len(l):
    var
      j = i
    while j > 0 and l[j-1] > l[j]:
      swap(l[j], l[j-1])
      j = j - 1
    i = i + 1

func insertionSort[T](l: var openArray[T]) =
  ## Sort your array similar to how you would sort your cards in your hand.
  ## You take a card `key` and insert it in the right position in your hand one
  ## at a time.
  for j in 1 .. l.high:
    var
      key = l[j]
      i = j - 1
    while i >= 0 and l[i] > key:
      l[i+1] = l[i]
      i.dec
    l[i+1] = key

proc testSort[T: SomeNumber](mySort: proc (x: var openArray[T]), size: Positive = 15,
  limit: SomeNumber = 100, verbose = true): bool =
  ## Test the sort function with a random array
  var limit = T(limit)
  var arr = newSeqWith(size, rand(limit))
  if verbose:
    echo "Before: ", arr
  mySort(arr)
  if verbose:
    echo "After: ", arr
  isSorted(arr)

proc testSort(mySort: proc (x: var openArray[char]), size: Positive = 15,
  limit: char = 'z', verbose = true): bool =
  ## Test the sort function with a random array
  var arr = newSeqWith[char](size, rand('a' .. limit))
  if verbose:
    echo "Before: ", arr
  mySort(arr)
  if verbose:
    echo "After: ", arr
  isSorted(arr)



when isMainModule:
  randomize()
  import std/unittest

  suite "Insertion Sort":
    test "Sort":
      check testSort(insertionSortAllSwaps[int])
      check testSort(insertionSort[int])
    test "Sort with limit 10":
      check testSort(insertionSortAllSwaps[int], 15, 10)
      check testSort(insertionSort[int], 15, 10)
    test "Sort with floating-point numbers":
      check testSort(insertionSort[float])
    test "Sort characters":
      check testSort(insertionSort[char])
