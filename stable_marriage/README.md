# Stable Marriage Problem
> Also known as the Stable Matching Problem

## Problem overview
The Stable Marriage Problem[^gs] involves finding a pairing between two equally sized sets of elements based on their preferences for each other. In the context of the Stable Marriage Problem, there are `n` men (contenders) and `n` women (receivers) with ranked preferences for members of the opposite group. The objective is to match men and women together so that there are no pairs in which **both** participants would prefer some other pairing over their current partners.

Stable Matching has real-world applications in various domains such as assigning graduating medical students to hospitals, assigning users to servers in distributed Internet services, and market design.

The theory of stable allocations and the practice of market design, which includes the Stable Matching problem, was recognised with the Nobel Prize in Economic Sciences in 2012, awarded to Alvin E. Roth and Lloyd S. Shapley.

## The Gale-Shapley Algorithm
The [Gale-Shapley algorithm](gale_shapley.nim), proposed by David Gale and Lloyd Shapley, is a widely used solution for the Stable Marriage Problem. It guarantees a stable matching (marriage) for all participants and has a time complexity of `O(n^2)`, where `n` is the number of contenders or receivers (men or women).

Key properties of the Gale-Shapley algorithm include:

- Yielding the best matching for all contenders among all possible stable matchings, but the worst for all receivers.
- Being truthful and group-strategy proof for contenders (no contender or their coalition can get a better outcome by misrepresenting their preferences).
- Allowing receivers to potentially manipulate their preferences for a better match.

The Algorithm guarantees that everyone gets matched and that the matches are stable (there's no other pairing for which both the contender and the receiver are more satisfied).

## Other algorithms

While the Gale-Shapley algorithm is popular due to its efficiency and stability guarantees, other algorithms[^other] exist with different trade-offs in stability, optimality, and computational complexity.

### Vande Vate algorithm

Vande Vate's algorithm[^rvv], also known as the Roth and Vande Vate (RVV) mechanism, is an alternative algorithm with the following differences, compared to Gale-Shapley:

- Starts with an arbitrary initial assignment of contenders to receivers, not with an empty matching.
- Allows introducing participants incrementally and let them iteratively reach a stable matching, making it an online algorithm[^online]. 
- Accommodates scenarios with changing preferences.

## Related Problems:
Several related problems stem from the Stable Matching Problem, including stable matching with indifference, the stable roommates problem, the hospitals/residents problem, and matching with contracts. These variations address scenarios with slightly different sets of constraints, such as: ties in preferences, a single pool of participants, multiple residents and hospitals/colleges, and different contract terms.

[^gs]: https://en.wikipedia.org/wiki/Stable_marriage_problem
[^other]: https://arxiv.org/pdf/2007.07121
[^rvv]: Alvin E Roth and John H Vande Vate. *Random paths to stability in two-sided matching.* Econometrica: Journal of the Econometric Society, pages 1475–1480, 1990
[^online]: https://en.wikipedia.org/wiki/Online_algorithm
