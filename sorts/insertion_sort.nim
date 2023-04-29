## Insertion Sort
#[
This algorithm sorts a collection by comparing adjacent elements.
When it finds that order is not respected, it moves the element compared
backward until the order is correct.  It then goes back directly to the
element's initial position resuming forward comparison.

https://en.wikipedia.org/wiki/Insertion_sort
]#

import std/[random]

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

when isMainModule:
  randomize()
  import std/unittest
  import ./testSort.nim

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
