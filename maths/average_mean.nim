import sequtils

proc mean(nums: seq[float]): float =
  ## Finds the mean of a list of numbers.
  ## Wiki: https://en.wikipedia.org/wiki/Mean
  ##
  ## Examples:
  ##
  ## ```nim
  ## echo mean(@[3, 6, 9, 12, 15, 18, 21])
  ## # Output: 12.0
  ## ```
  ## ```nim
  ## echo mean(@[5, 10, 15, 20, 25, 30, 35])
  ## # Output: 20.0
  ## ```
  ## ```nim
  ## echo mean(@[1, 2, 3, 4, 5, 6, 7, 8])
  ## # Output: 4.5
  ## ```
  ## ```nim
  ## echo mean(@[])
  ## # Error: List is empty
  ## ```
  if nums.len == 0:
    raise newException(ValueError, "List is empty")
  result = nums.sum() / float(nums.len)

when isMainModule:
  discard
