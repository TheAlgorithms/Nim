# Bubble sort
#[
Bubble sort, sometimes referred to as sinking sort, is a simple sorting algorithm that repeatedly steps through the input list element by element, comparing the current element with the one after it, swapping their values if needed. These passes through the list are repeated until no swaps had to be performed during a pass, meaning that the list has become fully sorted.
# https://en.wikipedia.org/wiki/Bubble_sort
]#

func bubbleSort[T](l: var openArray[T]) =
  let n = l.len
  for i in countDown(n - 1, 1):
    for j in 0 ..< i:
      if l[j] > l[j+1]:
        swap(l[j], l[j+1])
  

func bubbleSortOpt1[T](l: var openArray[T]) =
  let n = l.len
  for i in countDown(n - 1, 1):
    var flag: bool = true # Optimisation
    for j in 0 ..< i:
      if l[j] > l[j+1]:
        flag = false
        swap(l[j], l[j+1])
    if flag: # We can return/break early
      return

func bubbleSortWhileLoop[T](l: var openArray[T]) =
  ## The same optimization can be rewritten with
  ## a while loop
  let n = l.len
  var swapped = true
  while swapped:
    swapped = false
    for i in 1 ..< n:
      if l[i-1] > l[i]:
        swap l[i-1], l[i]
        swapped = true

func bubbleSortOpt2[T](l: var openArray[T]) =
  ## The n-th pass finds the n-th largest element
  ## So no need to look at the n last elements
  ## during the (n+1)-th pass
  var
    n = l.len
    swapped = true
  while swapped:
    swapped = false
    for i in 1 ..< n:
      if l[i-1] > l[i]:
        swap l[i-1], l[i]
        swapped = true
    dec n

when isMainModule:
  import std/[unittest, random]
  import ./testSort.nim
  randomize()

  suite "Insertion Sort":
    test "Sort":
      check testSort(bubbleSort[int])
      check testSort(bubbleSortOpt1[int])
      check testSort(bubbleSortWhileLoop[int])
      check testSort(bubbleSortOpt2[int])
    test "Sort with limit 10":
      check testSort(bubbleSort[int], 15, 10)
      check testSort(bubbleSortOpt1[int], 15, 10)
      check testSort(bubbleSortWhileLoop[int], 15, 10)
      check testSort(bubbleSortOpt2[int], 15, 10)
    test "Sort with floating-point numbers":
      check testSort(bubbleSort[float])
      check testSort(bubbleSortOpt1[float])
      check testSort(bubbleSortWhileLoop[float])
      check testSort(bubbleSortOpt2[float])
    test "Sort characters":
      check testSort(bubbleSort[char])
      check testSort(bubbleSortOpt1[char])
      check testSort(bubbleSortWhileLoop[char])
      check testSort(bubbleSortOpt2[char])

