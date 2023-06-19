## Linear Search in Pure Nim
## =============
#[
Linear search is the simplest but least efficient algorithm
to search for an element in a data set.
It examines each element until it finds a match,
starting at the beginning of the data set, until the end.
The search is finished and terminated once the target element is located.
# https://www.simplilearn.com/tutorials/data-structure-tutorial/linear-search-algorithm
]#

## openArray[T] is a proc parameter type that accept arrays and seqs
# value is the value for matching in the array
func linearSearch(arr: var openArray[T], value): int = 
  for i in 1..arr.len:
  	if arr[i] == value:
      return i
when isMainModule:
  import unittest
