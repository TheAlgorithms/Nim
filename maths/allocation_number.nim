# Non-overlapping Partitioning
## In a multi-threaded program, this algorithmm could be used to provide
## each worker thread with a block of non-overlapping bytes to work on.

runnableExamples:
  let numBytes = 100
  let numPartitions = 5
  let allocations = allocationNum(numBytes, numPartitions)
  doAssert allocations == @[
    0 .. 19,
    20 .. 39,
    40 .. 59,
    60 .. 79,
    80 .. 100
  ]
  
func allocationNum(numBytes: Natural, numPartitions: Positive): seq[Slice[Natural]] =
  ## Divide `numBytes` bytes into `numPartitions` non-overlapping partitions.
  if numPartitions > numBytes:
    raise newException(ValueError, "numPartitions must be <= numBytes")
  var
    bytesPerPartition = numBytes div numPartitions
    allocation_list: seq[Slice[Natural]] = @[]
  for i in Natural(0) ..< numPartitions:
    if i == numPartitions-1:
      allocation_list.add(Natural(i*bytesPerPartition) .. numBytes)
    else:
      allocation_list.add(Natural(i*bytesPerPartition) .. Natural((i+1)*bytesPerPartition-1))
  return allocation_list

when isMainModule:
  import std/unittest

  suite "Test `allocationNum`":
    test "Test `allocationNum` on a divisor of bytes (same partition sizes)":
      let allocations: seq[Slice[Natural]] = allocationNum(100, 5)
      check allocations == @[
        Natural(0) .. Natural(19),
        Natural(20) .. Natural(39),
        Natural(40) .. Natural(59),
        Natural(60) .. Natural(79),
        Natural(80) .. Natural(100)
      ]
    
    test "`allocationNum` on a non-divisor of bytes":
      let allocations: seq[Slice[Natural]] = allocationNum(104, 5)
      check allocations == @[
        Natural(0) .. Natural(19),
        Natural(20) .. Natural(39),
        Natural(40) .. Natural(59),
        Natural(60) .. Natural(79),
        Natural(80) .. Natural(104)
      ]
    
    test "`allocationNum` on more partitions than bytes":
      doAssertRaises(ValueError): discard allocationNum(0, 5)
      doAssertRaises(ValueError): discard allocationNum(1, 5)