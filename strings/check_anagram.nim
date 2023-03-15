## Check Anagram
## =============
## wiki: https://en.wikipedia.org/wiki/Anagram
##
## Two words are anagrams if:
## - They are made up of the same letters.
## - The letters are arranged differently.
## - The case of the characters in a word is ignored.
## - They are not the same word (a word is not an anagram of itself).
##
## A word is any string of characters `{'A'..'Z', 'a'..'z'}`. Other characters,
## including whitespace, numbers and punctuation, are considered invalid and
## raise a `ValueError` exception.
##
## Note: Generate full doc with `nim doc --docinternal check_anagram.nim`

runnableExamples:

  doAssert "coder".isAnagram("credo")

  doAssert not "Nim".isAnagram("Nim")

  doAssert not "parrot".isAnagram("rapport")

  doAssertRaises(ValueError): discard "Pearl Jam".isAnagram("Maple Jar")

## Tests
## -----
## This module includes test suites for each public function, which will run if
## the module is compiled as an executable.
##
## TODO
## ----
##
## - Unicode version of the algorithm.
## - Check if the arguably more idiomatic solution using whole-word operations
##   is beneficial or detrimental to the performance, compared to char-by-char
##   approach of this module.

{.push raises: [].}

type
  Map = array[range['a'..'z'], Natural] ## An associative array with a direct
                                        ## mapping from Char to a counter slot.

const
  UpperAlpha = {'A'..'Z'}
  LowerAlpha = {'a'..'z'}

func toLowerUnchecked(c: char): char {.inline.} =
  ## Lowers the case of an ASCII uppercase letter ('A'..'Z').
  ## No checks performed, the caller must ensure the input is a valid character.
  ##
  ## See also:
  ## * `strutils.toLowerAscii <https://nim-lang.org/docs/strutils.html#toLowerAscii%2Cchar>`_
  assert c in UpperAlpha
  # The difference between numerical values for chars of uppercase and
  # lowercase alphabets in the ASCII table is 32. Uppercase letters start from
  # 0b100_0001, so setting the sixth bit to 1 gives letter's lowercase pair.
  char(uint8(c) or 0b0010_0000'u8)

template normalizeChar(c: char) =
  ## Checks if the character is a letter and lowers its case.
  ##
  ## Raises a `ValueError` on other characters.
  if c in LowerAlpha: c
  elif c in UpperAlpha: toLowerUnchecked(c)
  else: raise newException(ValueError, "Character '" & c & "' is not a letter!")

func isAnagram*(wordA, wordB: openArray[char]): bool {.raises: ValueError.} =
  ## Checks if two words are anagrams of one another.
  ##
  ## Raises a `ValueError` on any non-letter character.
  if wordA.len != wordB.len: return false
  var seenDifferent = false
  var mapA, mapB: Map
  for chIdx in 0..<wordA.len:
    let (chA, chB) = (normalizeChar(wordA[chIdx]), normalizeChar(wordB[chIdx]))
    # Identical characters xor to 0, must meet at least one 1 (difference)
    seenDifferent = bool(ord(seenDifferent) or (ord(chA) xor ord(chB)))
    mapA[chA].inc()
    mapB[chB].inc()
  # words are not identical and letter counters match
  seenDifferent and (mapA == mapB)

func isAnagram(candidate, wordNormalized: openArray[char]; wordMap: Map): bool
  {.raises: ValueError.} =
  ## Checks if two words are anagrams of one another.
  ## Leverages the validated and lowercased `wordNormalized` and its
  ## pre-calculated letter map `wordMap` for one-to-many comparisons.
  ##
  ## Raises a `ValueError` on any non-letter character in `candidate`.
  if candidate.len != wordNormalized.len: return false
  var seenDifferent = false
  var candMap: Map
  for chIdx in 0..<candidate.len:
    let (chA, chB) = (normalizeChar(candidate[chIdx]), wordNormalized[chIdx])
    # Identical characters xor to 0, must meet at least one 1 (difference)
    seenDifferent = bool(ord(seenDifferent) or (ord(chA) xor ord(chB)))
    candMap[chA].inc()
  # words are not identical and letter counters match
  seenDifferent and (candMap == wordMap)

func filterAnagrams*(word: string; candidates: openArray[string]): seq[string]
  {.raises: ValueError.} =
  ## Checks if any of the candidates is an anagram of a `word` and returns them.
  ##
  ## Raises a `ValueError` on any non-letter character.
  var wordMap: Map
  var wordNormalized = newString(word.len)
  for chIdx, c in word.pairs():
    let c = normalizeChar(c)
    wordNormalized[chIdx] = c
    wordMap[c].inc()
  for candidate in candidates:
    if candidate.isAnagram(wordNormalized, wordMap): result.add(candidate)

when isMainModule:
  import std/unittest
  from std/sequtils import allIt, filterIt, mapIt

  suite "Check `isAnagram`":
    test "Only alphabetical characters are allowed":
      expect(ValueError): discard "n00b".isAnagram("8ooN")

    test "Detects an anagram":
      check "aceofbase".isAnagram("boafaeces")

    test "A word is not an anagram of itself":
      check not "nim".isAnagram("nim")

    test "A word is not an anagram of itself case-insensitively":
      check not "fnord".isAnagram("fNoRd")

    test "Character count matters":
      check not "tapper".isAnagram("patter")

    test "All matches":
      const word = "MilesDavis"
      const anagrams = ["VileSadism", "DevilsAmis", "SlimeDivas", "MassiveLid"]
      check anagrams.allIt(word.isAnagram(it))

    test "No matches":
      const word = "alice"
      const candidates = ["bob", "carol", "dave", "eve"]
      check candidates.allIt(not word.isAnagram(it))

    test "Detects anagrams case-insensitively":
      const word = "solemn"
      const candidates = ["LEMONS", "parrot", "MeLoNs"]
      check candidates.mapIt(word.isAnagram(it)) == [true, false, true]

    test "Does not detect anagram subsets":
      const word = "good"
      const candidates = @["dog", "goody"]
      check candidates.filterIt(word.isAnagram(it)).len == 0

  suite "Check `filterAnagrams`":
    test "Only alphabetical characters are allowed":
      expect(ValueError): discard "n00b".filterAnagrams(["8ooN", "1337"])

    test "A word is not an anagram of itself, case-insensitively":
      const candidates = ["fnord", "FnOrD"]
      check "fnord".filterAnagrams(candidates).len == 0

    test "Detects anagrams":
      const word = "MilesDavis"
      const anagrams = ["VileSadism", "DevilsAmis", "SlimeDivas", "MassiveLid"]
      check word.filterAnagrams(anagrams) == anagrams

    test "No matches":
      const word = "alice"
      const candidates = ["bob", "carol", "dave", "eve"]
      check word.filterAnagrams(candidates).len == 0

    test "Detects anagrams case-insensitively":
      const word = "solemn"
      const candidates = ["LEMONS", "parrot", "MeLoNs"]
      check word.filterAnagrams(candidates) == [candidates[0], candidates[2]]
