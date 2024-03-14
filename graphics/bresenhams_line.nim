## Bresenham's line algorithm

func computeStep(inStart, inEnd: int): int =
  if inStart < inEnd: 1 else: -1

func drawBresenhamLine*(posA, posB: (int, int)): seq[(int, int)] =
  ## returns a sequence of coordinates approximating the straights line
  ## between points `posA` and `posB`.
  ## These points are determined using the
  ## [Bresenham's line algorithm](https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm).
  ## This implementation balances the positive and negative errors between `x` and `y` coordinates.
  let
    dx = abs(posA[0]-posB[0])
    dy = -abs(posA[1]-posB[1])
    xStep = computeStep(posA[0], posB[0])
    yStep = computeStep(posA[1], posB[1])

  var
    difference = dx + dy
    res: seq[(int, int)] = @[]
    x = posA[0]
    y = posA[1]

  res.add((x, y))
  while (x, y) != posB:
    let doubleDifference = 2 * difference
    if doubleDifference >= dy:
      difference += dy
      x += xStep
    if doubleDifference <= dx:
      difference += dx
      y += yStep
    res.add((x, y))

  res

when isMainModule:
  import std/[unittest, sequtils, algorithm]
  suite "bresenhamLine":
    const testCases = [
      ("horizontal", (1, 0), (3, 0), @[(1, 0), (2, 0), (3, 0)]),
      ("vertical", (0, -1), (0, 1), @[(0, -1), (0, 0), (0, 1)]),
      ("trivial", (0, 0), (0, 0), @[(0, 0)]),
      ("diagonal", (0, 0), (3, 3), @[(0, 0), (1, 1), (2, 2), (3, 3)]),
      ("shiftedDiagonal", (5, 1), (8, 4), @[(5, 1), (6, 2), (7, 3), (8, 4)]),
      ("halfDiagonal",
        (0, 0), (5, 2),
        @[(0, 0), (1, 0), (2, 1), (3, 1), (4, 2), (5, 2)]),
      ("doubleDiagonal",
        (0, 0), (2, 5),
        @[(0, 0), (0, 1), (1, 2), (1, 3), (2, 4), (2, 5)]),
      ("line1",
        (2, 3), (8, 7),
        @[(2, 3), (3, 4), (4, 4), (5, 5), (6, 6), (7, 6), (8, 7)]),
      ("line2",
        (2, 1), (8, 5),
        @[(2, 1), (3, 2), (4, 2), (5, 3), (6, 4), (7, 4), (8, 5)]),
      ].mapIt:
        (name: it[0], posA: it[1], posB: it[2], line: it[3])

    func flipCoordinatesTuple(inPos: (int, int)): (int, int) =
      (inPos[1], inPos[0])

    func flipCoordinates(line: seq[(int, int)]): seq[(int, int)] =
      line.map(flipCoordinatesTuple)

    func reverseLine(line: seq[(int, int)]): seq[(int, int)] =
      toSeq(reversed(line))

    for tc in testCases:
      test tc.name:
        checkpoint("returns expected result")
        check drawBresenhamLine(tc.posA, tc.posB) == tc.line

        checkpoint("is symmetric")
        check drawBresenhamLine(tc.posB, tc.posA) == reverseLine(tc.line)

        checkpoint("returns expected result when coordinates are flipped")
        check drawBresenhamLine(flipCoordinatesTuple(tc.posA),
            flipCoordinatesTuple(tc.posB)) == flipCoordinates(tc.line)

        checkpoint("is symmetric when coordinates are flipped")
        check drawBresenhamLine(flipCoordinatesTuple(tc.posB),
            flipCoordinatesTuple(tc.posA)) == reverseLine(flipCoordinates(tc.line))
