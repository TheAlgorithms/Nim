import unittest
## Insertion Sort
## ==============
## Insertion Sort is a simple sorting algorithm, 
## that builds the final sorted array (or list) one item at a time.
## It is much less efficient on large lists than more advanced algorithms
## such as quicksort, heapsort, or merge sort.
## There are several advantages though:
## 1. Simple implementation
## 2. Efficiency for small or almost sorted data sets
## 
## The basic idea is the following:
## 1. Start from the second element (index 1) and compare to the first element
## 2. If the second element is smaller, swap them.
## 3. Move to the next element and compare it to the element(s) to the left.
## --> swap that element until the correct position is found! 
## (E.g there is no smaller element to the left)
## 4. Repeat until the array (or list) is sorted.
## 
## The time complexity is O(n²) in the worst and average case. 
## This is because it may need to compare and swap each element with
## all elements on the left. (E.g an array that is sorted in reverse (big to small))
## The best case time complexity is O(n) when the array is already sorted.
## 
## The space complexity of insertion sort is O(1).
## https://en.wikipedia.org/wiki/Insertion_sort


# A function, that checks wether or not the given sequence is sorted or not
# it returns true when it's sorted, otherwise false
proc isSorted[T: Ordinal](arr: seq[T]): bool =
  for i in 1..<arr.len:
    if arr[i] < arr[i - 1]:
      return false
  return true

# An implementation of the insertion sort algorithm
proc insertionSort[T: Ordinal](arr: var seq[T]): seq[T] =
  for i in 1..<arr.len:
    let key = arr[i]
    var j = i - 1

    while j >= 0 and arr[j] > key:
      arr[j + 1] = arr[j]
      dec(j)
    arr[j + 1] = key

  return arr

when isMainModule:

  var
    empty: seq[int] = @[]
    single: seq[int] = @[1]
    unsorted: seq[int] = @[5, 9, 1, 2, 4, 6]
    unsortedMultiples: seq[int] = @[3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
    sorted: seq[int] = @[1, 2, 3, 4, 5, 6]
    chars: seq[char] = @['5', '9', '1', '2', '4', '6']
    sortedChars: seq[char] = @['1', '2', '3', '4', '5', '6']


  template checkInsertionSort[T: Ordinal](arr: seq[T]): untyped =
    let sortedArr = insertionSort(arr)
    check isSorted(sortedArr)

#The basic idea is to imply, that if the isSorted function returns true, the sequence
#is sorted. Otherwise it would return false and fail the tests.
#We then use our insertion sort to sort a sequence and afterwards check, wether it's
#true or not. 
  suite "Insertion Sort Tests":
    test "Empty list":
      checkInsertionSort(empty)

    test "One element in a list":
      checkInsertionSort(single)
    
    test "Unsorted list with duplicates":
      checkInsertionSort(unsortedMultiples)

    test "Pre-sorted list":
      checkInsertionSort(sorted)
    
    test "Unsorted list without duplicates":
      checkInsertionSort(unsorted)
    
    test "Sorting chars":
      checkInsertionSort(chars)
    
    test "Sorting pre-sorted chars":
      checkInsertionSort(sortedChars)