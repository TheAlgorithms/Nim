## Test sorting algorithms
import std/[sequtils, random, algorithm]

proc testSort*[T: SomeNumber](mySort: proc (x: var openArray[T]), size: Positive = 15,
  limit: SomeNumber = 100, verbose = false): bool =
  ## Test the sort function with a random array
  var limit = T(limit)
  var arr = newSeqWith(size, rand(limit))
  if verbose:
    echo "Before: ", arr
  mySort(arr)
  if verbose:
    echo "After: ", arr
  isSorted(arr)

proc testSort*(mySort: proc (x: var openArray[char]), size: Positive = 15,
  limit: char = 'z', verbose = false): bool =
  ## Test the sort function with a random array
  var arr = newSeqWith[char](size, rand('a' .. limit))
  if verbose:
    echo "Before: ", arr
  mySort(arr)
  if verbose:
    echo "After: ", arr
  isSorted(arr)
