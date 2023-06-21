## Gale-Shapley
## ============
##
## This module implements the classical Gale-Shapley_ algorithm for solving
## the stable matching problem.
##
## The following example uses the implemented algorithm to solve the task of
## stable matching as posed by RosettaCode_:
##
## .. _Gale-Shapley: https://en.wikipedia.org/wiki/Gale%E2%80%93Shapley_algorithm
## .. _RosettaCode:  https://rosettacode.org/wiki/Stable_marriage_problem
##
## * Finds a stable set of matches ("engagements").
## * Randomly destabilizes the matches and checks the results for stability.
##
## Example starts with a discarded string containing a possible output:
runnableExamples:
  discard """
  abe 💑 ivy, bob 💑 cath, col 💑 dee, dan 💑 fay, ed 💑 jan,
  fred 💑 bea, gav 💑 gay, hal 💑 eve, ian 💑 hope, jon 💑 abi
  Current matching stability: ✓ Stable
  Swapping matches for random contenders: bob <=> gav
  abe 💑 ivy, bob 💑 gay, col 💑 dee, dan 💑 fay, ed 💑 jan,
  fred 💑 bea, gav 💑 cath, hal 💑 eve, ian 💑 hope, jon 💑 abi
  Current matching stability: ✗ Unstable
  💔 bob prefers cath over gay
  💔 cath prefers bob over gav
  """

  import std/[random, strutils, sequtils, strformat, options]

  const
    MNames = ["abe", "bob", "col", "dan", "ed", "fred", "gav", "hal", "ian", "jon"]
    FNames = ["abi", "bea", "cath", "dee", "eve", "fay", "gay", "hope", "ivy", "jan"]
    MPreferences = [
      ["abi", "eve", "cath", "ivy", "jan", "dee", "fay", "bea", "hope", "gay"],
      ["cath", "hope", "abi", "dee", "eve", "fay", "bea", "jan", "ivy", "gay"],
      ["hope", "eve", "abi", "dee", "bea", "fay", "ivy", "gay", "cath", "jan"],
      ["ivy", "fay", "dee", "gay", "hope", "eve", "jan", "bea", "cath", "abi"],
      ["jan", "dee", "bea", "cath", "fay", "eve", "abi", "ivy", "hope", "gay"],
      ["bea", "abi", "dee", "gay", "eve", "ivy", "cath", "jan", "hope", "fay"],
      ["gay", "eve", "ivy", "bea", "cath", "abi", "dee", "hope", "jan", "fay"],
      ["abi", "eve", "hope", "fay", "ivy", "cath", "jan", "bea", "gay", "dee"],
      ["hope", "cath", "dee", "gay", "bea", "abi", "fay", "ivy", "jan", "eve"],
      ["abi", "fay", "jan", "gay", "eve", "bea", "dee", "cath", "ivy", "hope"]
    ]
    FPreferences = [
      ["bob", "fred", "jon", "gav", "ian", "abe", "dan", "ed", "col", "hal"],
      ["bob", "abe", "col", "fred", "gav", "dan", "ian", "ed", "jon", "hal"],
      ["fred", "bob", "ed", "gav", "hal", "col", "ian", "abe", "dan", "jon"],
      ["fred", "jon", "col", "abe", "ian", "hal", "gav", "dan", "bob", "ed"],
      ["jon", "hal", "fred", "dan", "abe", "gav", "col", "ed", "ian", "bob"],
      ["bob", "abe", "ed", "ian", "jon", "dan", "fred", "gav", "col", "hal"],
      ["jon", "gav", "hal", "fred", "bob", "abe", "col", "ed", "dan", "ian"],
      ["gav", "jon", "bob", "abe", "ian", "dan", "hal", "ed", "col", "fred"],
      ["ian", "col", "hal", "gav", "fred", "bob", "abe", "ed", "jon", "dan"],
      ["ed", "hal", "gav", "abe", "bob", "jon", "col", "ian", "fred", "dan"]
    ]
    # Recipient ids in descending order of preference
    ContenderPrefs = initContenderPrefs(MPreferences, FNames)
    # Preference score for each contender's id
    RecipientPrefs = initRecipientPrefs(FPreferences, MNames)

  proc randomPair(max: Positive): (Natural, Natural) =
    ## Returns a random fair pair of non-equal numbers up to and including `max`
    let a = rand(max)
    var b = rand(max - 1)
    if b == a: b = max
    (a.Natural, b.Natural)

  proc perturbPairs(ms: var Matches) =
    randomize()
    let (a, b) = randomPair(ms.contenderMatches.len - 1)
    echo "Swapping matches between random contenders: ",
          MNames[a], " <=> ", MNames[b]
    template swap(arr: var openArray[int]; a, b: int) = swap(arr[a], arr[b])
    ms.contenderMatches.swap(a, b)
    ms.recipientMatches.swap(ms.contenderMatches[a], ms.contenderMatches[b])

  proc checkPairStability(matches: Matches; recipientPrefs,
      contenderPrefs: openArray[Ranking]): bool =
    let clashes = checkMatchingStability(matches, contenderPrefs, recipientPrefs,
                                       MNames, FNames)
    if clashes.isSome():
      let (clC, clR) = clashes.get()
      echo "\u2717 Unstable"
      echo &"\u{0001F494} {clC.person} prefers {clC.prefers} over {clC.match}"
      echo &"\u{0001F494} {clR.person} prefers {clR.prefers} over {clR.match}"
      false
    else:
      echo "\u2713 Stable"
      true

  proc render(contMatches: seq[int]; cNames, rNames: openArray[
      string]): string =
    for c, r in pairs(contMatches):
      result.add(cNames[c] & " \u{0001F491} " & rNames[r])
      if c < contMatches.high: result.add(", ")

  var matches = stableMatching(ContenderPrefs, RecipientPrefs)
  block:
    echo render(matches.contenderMatches, MNames, FNames)
    stdout.write "Current matching stability: "
    let areStable = checkPairStability(matches, RecipientPrefs, ContenderPrefs)
    doAssert areStable

  perturbPairs(matches)
  block:
    echo render(matches.contenderMatches, MNames, FNames)
    stdout.write "Current matching stability: "
    let areStable = checkPairStability(matches, RecipientPrefs, ContenderPrefs)
    doAssert areStable == false

#===============================================================================
{.push raises: [].}

import std/options
from std/sequtils import newSeqWith

type
  Ranking*[T: int] = concept c ## A wide concept allowing `stableMatching`
                    ## to accept both arrays and sequences in an openArray.
    c.len is Ordinal
    c[int] is T

  Matches* = object             ## An object to keep the calculated matches.
                      ## Both fields hold the same information from opposite points of view,
                      ## providing a way to look up matching in 0(1) (without linear search).
    contenderMatches*: seq[int] ## Matched recipients for each contender
    recipientMatches*: seq[int] ## Matched contenders for each recipient

  Clash* = tuple[person, match, prefers: string]

# Helper functions to prepare the numerical representation of preferences from
# an array of arrays of names in order of descending preference.
func initContenderPrefs*[N: static int](prefs: array[N, array[N, string]];
    rNames: openArray[string]): array[N, array[N, int]] {.compileTime.} =
  ## Contender's preferences hold the recipient ids in descending order
  ## of preference.
  for c, ranking in pairs(prefs):
    for rank, recipient in pairs(ranking):
      assert recipient in ranking
      result[c][rank] = rNames.find(recipient)

func initRecipientPrefs*[N: static int](prefs: array[N, array[N, string]];
    cNames: openArray[string]): array[N, array[N, int]] {.compileTime.} =
  ## Recipient's preferences hold the preference score for each contender's id.
  for r, ranking in pairs(prefs):
    for rank, contender in pairs(ranking):
      assert contender in ranking
      result[r][cNames.find(contender)] = rank

func invertPrefs*[N: static int](prefs: array[N, array[N, int]]):
                                 array[N, array[N, int]] =
  ## Converts each element of `prefs` from Ids in order of decreasing
  ## preference to ranking score for each Id.
  ## Used to convert from format used for Contenders to one used for Recipients.
  for rId, ranking in prefs.pairs():
    for rank, id in ranking.pairs():
      result[rId][id] = rank

func stableMatching*(contenderPrefs, recipientPrefs: openArray[
    Ranking]): Matches =
  ## Calculates a stable matching for a given set of preferences.
  ## Returns an object with corresponding match ids
  ## for each contender and each recipient.
  ##
  ## Each element of the argument arrays is an array of ints, meaning slightly
  ## different things:
  ## * `contenderPrefs`: recipient ids in descending order of preference
  ## * `recipientPrefs`: preference score for each contender's id
  ##
  assert recipientPrefs.len == recipientPrefs[0].len
  assert contenderPrefs.len == contenderPrefs[0].len
  assert recipientPrefs.len == contenderPrefs.len
  let rosterLen = recipientPrefs.len
  var
    # Initializing result sequences with -1, meaning "unmatched"
    recMatches = newSeqWith(rosterLen, -1)
    contMatches = newSeqWith(rosterLen, -1)
    # Queue holding the currently considered "preference score"
    # (idx of contenderPrefs) for each contender.
    contQueue = newSeqWith(rosterLen, 0)
  template match(c, r: Natural) =
    # Recipient accepts contender, the match is stored
    contMatches[c] = r
    recMatches[r] = c
  while contMatches.contains(-1): # While exist unmatched contenders...
    for c in 0..<rosterLen: # for each contender...
      if contMatches[c] == -1: # if they are yet unmatched...
        # Proposing to the queued recipient
        let r = contenderPrefs[c][contQueue[c]]
        inc(contQueue[c]) # Queue next preferred recipient for this contender
        let curRecMatch = recMatches[r] # Recipient's match index or -1 (vacant)
        if curRecMatch == -1: # Recipient is also unmatched
          match(c, r)
        # Recipient is matched, but contender is more preferable
        elif recipientPrefs[r][c] < recipientPrefs[r][curRecMatch]:
          contMatches[curRecMatch] = -1 # Vacate current recipient's match
          match(c, r)
        # else: contender's proposition is rejected
  Matches(contenderMatches: contMatches, recipientMatches: recMatches)


func checkMatchingStability*(matches: Matches;
      contenderPrefs, recipientPrefs: openArray[Ranking];
      cNames, rNames: openArray[string]): Option[(Clash, Clash)] =
  ## Checks if any matched pair in the current matching is unstable,
  ## i.e. for **both** of the pair there is no alternative matches preferred
  ## to the current match.
  for c, curMatch in matches.contenderMatches.pairs(): # For each contender...
    # Preference score for the current match
    let curMatchScore = contenderPrefs[c].find(curMatch)
    # Try every recipient with higher score, if any
    for preferredRec in 0..<curMatchScore:
      # Recipient to check against
      let checkedRec = contenderPrefs[c][preferredRec]
      # Current match of checked recipient
      let curRecMatch = matches.recipientMatches[checkedRec]
      # If score of the curRecMatch is worse (>) than score of checked contender
      if recipientPrefs[checkedRec][curRecMatch] > recipientPrefs[checkedRec][c]:
        let clashC = (person: cNames[c], match: rNames[checkedRec],
            prefers: rNames[curMatch])
        let clashR = (person: rNames[checkedRec], match: cNames[c],
            prefers: cNames[curRecMatch])
        return some((clashC, clashR))
  none((Clash, Clash))


when isMainModule:
  import std/unittest

  suite "Stable Matching":
    test "RosettaCode":
      const
        MNames = ["abe", "bob", "col"]
        FNames = ["abi", "bea", "cath"]
        MPreferences = [
          ["abi", "cath", "bea"],
          ["cath", "abi", "bea"],
          ["abi", "bea", "cath"]]
        FPreferences = [
          ["bob", "abe", "col"],
          ["bob", "abe", "col"],
          ["bob", "col", "abe"]]
        ContenderPrefs = initContenderPrefs(MPreferences, FNames)
        RecipientPrefs = initRecipientPrefs(FPreferences, MNames)

      func isStable(matches: Matches;
                    contenderPrefs, recipientPrefs: openArray[Ranking]): bool =
        let c = checkMatchingStability(matches, contenderPrefs, recipientPrefs,
            MNames, FNames)
        c.isNone()

        let matches = stableMatching(ContenderPrefs, RecipientPrefs)
        # abe+abi, bob+cath, col+bea
        check matches.contenderMatches == @[0, 2, 1]
        check matches.recipientMatches == @[0, 2, 1]
        check isStable(matches, ContenderPrefs, RecipientPrefs)

    test "TheAlgorithms/Python":
      const DonorPrefs = [[0, 1, 3, 2], [0, 2, 3, 1], [1, 0, 2, 3], [0, 3, 1, 2]]
      const RecipientRrefs = invertPrefs([[3, 1, 2, 0], [3, 1, 0, 2],
                                          [0, 3, 1, 2], [1, 0, 3, 2]])
      let matches = stableMatching(DonorPrefs, RecipientRrefs)
      check matches.contenderMatches == @[1, 2, 3, 0]
      check matches.recipientMatches == @[3, 0, 1, 2]
