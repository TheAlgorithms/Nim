## Merge Sort
## Add Description
{.push raises: [].}

# TODO: proc mergeSort[T](l: var openArray[T]) =
proc merge[T](list: var openArray[T], p, q, r: Natural) =
  ## Merge two lists that have been sorted
  ## Assumes all elements of `list` are less than
  ## or equal to (T.high - 1) !
  let
    n1 = q - p + 1
    n2 = r - q
  var
    L = newSeq[T](n1 + 1)
    R = newSeq[T](n2 + 1)
  for i in 0 ..< n1:
    L[i] = list[p + i]
  for j in 0 ..< n2:
    R[j] = list[q + j + 1]
  L[n1] = T.high
  R[n2] = T.high
  var
    i = 0
    j = 0
  for k in p .. r:
    if L[i] <= R[j]:
      list[k] = L[i]
      i.inc
    else:
      list[k] = R[j]
      j.inc


proc mergeSort[T](list: var openArray[T], first, last: Natural) =
  ## Division step
  ## We split the list in two equal parts and work
  ## separately on each of them
  if first < last:
    let half = (first + last) div 2
    mergeSort(list, first, half)
    mergeSort(list, half + 1, last)
    merge(list, first, half, last)


func mergeSort[T](list: var openArray[T]) =
  ## Top level procedure
  ## O(n * log(n)) in average complexity where n = l.len
  mergeSort(list, list.low, list.high)


when isMainModule:
  import std/[unittest, random]
  import ./testSort
  randomize()

  suite "Merge Sort":
    test "Integers":
      check testSort mergeSort[int]
    test "Float":
      check testSort mergeSort[float]
    test "Char":
      check testSort mergeSort[char]
