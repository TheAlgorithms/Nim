## Manacher's algorithm
## --------------------
##
## Determine the longest palindrome in a string in linear time in its length
## with Manacher's algorithm.
## Inspired from:
## https://github.com/jilljenn/tryalgo/blob/master/tryalgo/manacher.py
## https://en.wikipedia.org/wiki/Longest_palindromic_substring
##
## :time complexity: O(n) where n is the string's length.

import std/[strutils, sequtils, sets]
{.push raises: [].}

runnableExamples:
  let example1 = "cabbbab"
  doAssert(manacherString(example1) == "abbba")
  doAssert(manacherIndex(example1) == 1 .. 5)
  doAssert(manacherLength(example1) == 5)

func manacherIndex*(s: string): HSlice[int, int] {.raises: [ValueError].} =
  ## Longest palindrome in a string by Manacher
  ## :param s: string, lowercase ascii, no whitespace
  ## :returns: indexes i,j such that s\[i:j\] is the longest palindrome in s
  ## :time complexity: O(n) where n is the string's length.
  ## All the indexes refer to an intermediate string t
  ## of the form "^#a#b#a#a#$" for s="abaa"
  if s.len == 0:
    raise newException(ValueError, "Empty string")
  let extraSymbols = toHashSet(['$', '^', '#'])
  let letters = toHashSet(s.toLowerAscii)
  assert disjoint(extraSymbols, letters) # Forbidden letters
  if s == "":
    return 0 .. 1
  let s = "^#" & join(s, "#") & "#$"
  var
    center = 1
    distance = 1
    p = repeat(0, len(s)) # Palindrome radii for each index in s
  for index in 2 ..< len(s)-1:
    # reflect index with respect to center
    let mirror = 2 * center - index # = center - (index - center)
    p[index] = max(0, min(distance - index, p[mirror]))
    # grow palindrome centered in i
    while s[index + 1 + p[index]] == s[index - 1 - p[index]]:
      p[index] += 1
    # adjust center if necessary
    if index + p[index] > distance:
      center = index
      distance = index + p[index]
  # find the argmax index in p
  var
    j = maxIndex(p)
    k = p[j]
  return (j - k) div 2 ..< (j + k) div 2 # extract solution

func manacherString*(s: string): string {.raises: [ValueError].} =
  ## Returns the greatest palindromic substring in `s`.
  return s[manacherIndex(s)]

func manacherLength*(s: string): int {.raises: [ValueError].} =
  ## Returns the length of the greatest palindromic substring in `s`.
  let
    res = manacherIndex(s)
    (i, j) = (res.a, res.b)
  return j - i + 1

when isMainModule:
  import std/unittest
  suite "Manacher's algorithm":
    test "Simple palindrome":
      check manacherIndex("abbbab") == 0 .. 4
      check manacherLength("abbbab") == 5
      check manacherString("abbbab") == "abbba"

    test "Single letter palindrome":
      check manacherIndex("abcab") == 0 .. 0
      check manacherLength("abcab") == 1
      check manacherString("abcab") == "a"

    test "Palindrome is full string":
      check manacherIndex("telet") == 0 .. 4
      check manacherLength("telet") == 5
      check manacherString("telet") == "telet"

    test "Empty string":
      doAssertRaises(ValueError):
        discard manacherIndex("")
      doAssertRaises(ValueError):
        discard manacherLength("")
      doAssertRaises(ValueError):
        discard manacherString("")
