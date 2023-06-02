## Shell Sort
#[
Shellsort, also known as Shell sort or Shell's method,
is an in-place comparison sort. It can be seen as either a generalization
of sorting by exchange (bubble sort) or sorting by insertion
(insertion sort).
Shell sort is:
- unstable
- adaptive (executes faster when the input is partially sorted
- Its time complexity is an open problem
References:
https://en.wikipedia.org/wiki/Shellsort
https://github.com/ringabout/data-structure-in-Nim/blob/master/sortingAlgorithms/shellSort.nim
]#
{.push raises: [].}

func shell2Sort[T](list: var openarray[T]) =
  var h = list.len
  while h > 0:
    h = h div 2
    for i in h ..< list.len:
      let k = list[i]
      var j = i
      while j >= h and k < list[j-h]:
        list[j] = list[j-h]
        j -= h
      list[j] = k


func shell3Sort*[T](x: var openArray[T]) =
  ## https://github.com/ringabout/data-structure-in-Nim/blob/master/shellSort.nim
  let length = len(x)
  var size = 1
  while size < length:
    size *= 3 + 1
  while size >= 1:
    for i in size ..< length:
      let temp = x[i]
      for j in countdown(i, size, size):
        if x[j - size] > temp:
          x[j] = x[j - size]
        else:
          x[j] = temp
          break
    size = size div 3


func shellSort[T](list: var openArray[T]) =
  ## A gap of 1 is an insertion sort algorithm
  ## Optimal gap sequence is referenced here: https://oeis.org/A102549
  const gaps = [701, 301, 132, 57, 23, 10, 4, 1]  # Ciura gap sequence
  for gap in gaps:
    for i in gap .. list.high:
      var
        temp = list[i]
        j = i
      while (j >= gap and list[j - gap] > temp):
        list[j] = list[j - gap]
        j.dec gap
      list[j] = temp


when isMainModule:
  import std/[unittest, random]
  import ./testSort
  randomize()

  suite "Shell Sort":
    test "Integers":
      check testSort shellSort[int]
    test "Float":
      check testSort shellSort[float]
    test "Char":
      check testSort shellSort[char]
