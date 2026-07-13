## Selection Sort
## Add description
{.push raises: [].}

func selectionSort[T](l: var openArray[T]) =
  let n = l.len
  for i in 0 .. n-2:
    var
      mini = l[i]
      idx_min = i
    for j in i ..< n:
      if l[j] < mini:
        mini = l[j]
        idx_min = j
    if idx_min != i:
      swap(l[idx_min], l[i])

when isMainModule:
  import std/[unittest, random]
  import test_sorts
  randomize()

  suite "Selection Sort":
    test "Integers":
      check testSort selectionSort[int]
    test "Float":
      check testSort selectionSort[float]
    test "Char":
      check testSort selectionSort[char]
