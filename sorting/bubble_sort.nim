## Bubble Sort
##
## Define function, bubble_sort()
## Pass in array "arr" as parameter
proc bubble_sort(arr: var openarray[int]) =
  ## Optimization: if array is already sorted,
  ## it doesn't need to do this process
  var swapped = false
  ## Iterate through arr
  for i in 0 .. high(arr) - 1:
    ## high(arr) also work but outer loop will
    ## repeat 1 time more.
    ## Last i elements are already in place
    for j in 0 .. high(arr) - i - 1:
      ## Go through array from 0 to length of arr - i - 1
      ## Swap if the element found is greater
      ## than the next element
      if arr[j] > arr[j + 1]:
        swap arr[j], arr[j + 1]
        swapped = true

    if not swapped:
      ## if no need to make a single swap, just exit.
      return


var arr = @[5, 6, 2, 1, 3]

bubble_sort(arr)

echo repr(arr)
