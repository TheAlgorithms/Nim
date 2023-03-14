## In a multi-threaded download, this algorithmm could be used to provide
## each worker thread with a block of non-overlapping bytes to download.

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
  
func allocationNum(numBytes: Natural, numPartitions: Natural): seq[Slice[Natural]] =
  ## Divide `numBytes` bytes into `numPartitions` non-overlapping partitions.
  if numPartitions <= 0:
    raise newException(ValueError, "numPartitions must be > 0")
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
    test "Test `allocationNum`":
      let allocations: seq[Slice[Natural]] = allocationNum(100, 5)
      check allocations == @[
        Natural(0) .. 19,
        Natural(20) .. 39,
        Natural(40) .. 59,
        Natural(60) .. 79,
        Natural(80) .. 100
      ]
    
    test "`allocationNum` on 0 partitions":
      doAssertRaises(ValueError): discard allocationNum(5, 0)
    
    test "`allocationNum` on more partitions than bytes":
      doAssertRaises(ValueError): discard allocationNum(0, 5)
  
  echo allocationNum(0, 5)