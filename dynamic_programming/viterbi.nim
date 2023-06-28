## Viterbi
{.push raises: [].}

type
  HiddenMarkovModel[S] = ref object
    states: seq[S]
    startProbability: seq[float] # Sum of all elements must be 1
    transitionProbability: seq[seq[float]] # Sum of all elements in each row must be 1
    emissionProbability: seq[seq[float]] # Sum of all elements in each row must be 1

func viterbi*[S, O](hmm: HiddenMarkovModel[S], observations: seq[O]): seq[S] =
  var
    probabilities = newSeq[seq[float]](len(observations))
    backpointers = newSeq[seq[int]](len(observations))

  # Initialization
  for i in 0 ..< len(observations):
    probabilities[i] = newSeq[float](len(hmm.states))
    backpointers[i] = newSeq[int](len(hmm.states))

  for state in 0 ..< len(hmm.states):
    probabilities[0][state] = hmm.startProbability[state] *
     hmm.emissionProbability[state][observations[0].ord]
    backpointers[0][state] = 0

  # Forward Pass - Derive the probabilities
  for nObs in 1 ..< len(observations):
    var
      obs = observations[nObs].ord
    for state in 0 ..< len(hmm.states):
      # Compute the argmax for probability of the current state
      var
        maxProb = -1.0
        maxProbState = 0
      for priorState in 0 ..< len(hmm.states):
        var
          prob = probabilities[nObs - 1][priorState] *
          hmm.transitionProbability[priorState][state] *
          hmm.emissionProbability[state][obs]
        if prob > maxProb:
          maxProb = prob
          maxProbState = priorState
      # Update probabilities and backpointers
      probabilities[nObs][state] = maxProb
      backpointers[nObs][state] = maxProbState

  # Final observation
  var
    maxProb = -1.0
    maxProbState = 0
  for state in 0 ..< len(hmm.states):
    if probabilities[len(observations) - 1][state] > maxProb:
      maxProb = probabilities[len(observations) - 1][state]
      maxProbState = state

  result = newSeq[S](len(observations))
  result[^1] = hmm.states[maxProbState]

  # Backward Pass - Derive the states from the probabilities
  for i in 1 ..< len(observations):
    result[^(i+1)] = hmm.states[backpointers[^i][maxProbState]]
    maxProbState = backpointers[^i][maxProbState]

when isMainModule:
  import std/unittest

  suite "Viterbi algorithm":
    test "Example from Wikipedia":
      type
        States = enum
          Healthy, Fever
        Observations = enum
          Normal, Cold, Dizzy
      var
        hmm = HiddenMarkovModel[States]()
        observations = @[Normal, Cold, Dizzy]
      hmm.states = @[Healthy, Fever]
      hmm.startProbability = @[0.6, 0.4]
      hmm.transitionProbability = @[@[0.7, 0.3], @[0.4, 0.6]]
      hmm.emissionProbability = @[@[0.5, 0.4, 0.1], @[0.1, 0.3, 0.6]]
      check viterbi(hmm, observations) == @[Healthy, Healthy, Fever]
