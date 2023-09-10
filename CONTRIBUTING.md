# Contributing guidelines

Welcome to [TheAlgorithms/Nim](https://github.com/TheAlgorithms/Nim)!

We are very happy that you are considering working on algorithm and data structure implementations in Nim! This repository is meant to be referenced and used by learners from all over the globe, and we aspire to maintain the highest possible quality of the code presented here. This is why we ask you to **read all of the following guidelines beforehand** to know what we expect of your contributions. If you have any doubts about this guide, please feel free to [state them clearly in an issue](https://github.com/TheAlgorithms/Nim/issues/new) or ask the community in [Discord](https://the-algorithms.com/discord).

## Table Of Contents

* [What is an Algorithm?](#what-is-an-algorithm)
* [Contributor agreement](#contributor-agreement)
* [Contribution guidelines](#contribution-guidelines)
  + [Implementation requirements](#implementation-requirements)
  + [Nim Coding Style](#nim-coding-style)
    - [Readability and naming conventions](#readability-and-naming-conventions)
    - [Compilation](#compilation)
    - [Types](#types)
    - [Result return](#result-return)
    - [Exceptions and side-effects](#exceptions-and-side-effects)
    - [Documentation, examples and tests](#documentation-examples-and-tests)
    - [Other](#other)
  + [Minimal example](#minimal-example)
  + [Submissions Requirements](#submissions-requirements)

## What is an Algorithm?

An Algorithm is one or more functions that:

- take one or more inputs,
- perform some internal calculations or data manipulations,
- return one or more outputs,
- have minimal side effects (Examples of side effects: `echo()`, `rand()`, `read()`, `write()`).

## Contributor agreement

Being one of our contributors, you agree and confirm that:

- Your work will be distributed under [MIT License](LICENSE.md) once your pull request is merged.
- Your work meets the standards of this guideline.

## Contribution guidelines

We appreciate any contribution, from fixing a grammar mistake in a comment to implementing complex algorithms. Please check the [directory](DIRECTORY.md) and [issues](https://github.com/TheAlgorithms/Nim/issues/) for an existing (or declined) implementation of your algorithm and relevant discussions.

**New implementations** are welcome! This includes new solutions for a problem, different representations for a data structure, and algorithm design with different complexity or features.

**Improving documentation and comments** and **adding tests** is also highly welcome.

**Identical implementations** are not allowed.

### Implementation requirements

- The unit of an implementation we expect is a [**Nim module**](https://nim-lang.org/docs/manual.html#modules). Although the main goals of this repository are educational, the module form mirrors a real-world scenario and makes it easy to use the code from this repository in other projects.
- The first line must contain the canonical title of the module prefixed by double hashes (`## Title Of The Module`). This title is used in this repository's automation for populating the [Directory](DIRECTORY.md).
- The module should be thoroughly documented with doc comments. Follow the [Nim documentation style](https://nim-lang.org/docs/docstyle.html).
- The file begins with the module-level documentation with the general description and explanation of the algorithm/data structure. If possible, please include:
  * Any restrictions of the implementation and any constraints for the input data.
  * An overview of use cases.
  * Recommendations for when to use or avoid using it.
  * Comparison with the alternatives.
  * Links to source materials and further reading.
- Use intuitive and descriptive names for objects, functions, and variables.
- Return all calculation results instead of printing or plotting them.
- This repository is not simply a compilation of *how-to* examples for existing Nim packages and routines. Each algorithm implementation should add unique value. It is fine to leverage the standard library or third-party packages as long as it doesn't substitute writing the algorithm itself. In other words, you don't need to reimplement a basic hash table ([`std/tables`](https://nim-lang.org/docs/tables.html)) each time you need to use it, unless it is the goal of the module.
- Avoid importing third-party libraries. Only use those for complicated algorithms and only if the alternatives of relying on the standard library or including a short amount of the appropriately licensed external code are not feasible.
- Include tests that cover valid and erroneous input values and the appropriate edge-cases. See [Documentation, examples and tests](#documentation-examples-and-tests) below.

### Nim Coding Style

#### Readability and naming conventions

We want your work to be readable by others; therefore, we encourage you to follow the official [Nim Coding Style](https://nim-lang.org/docs/nep1.html).

- Help your readers by using **descriptive names** that eliminate the need for redundant comments.
- Follow Nim naming conventions: camelCase for variables and functions, PascalCase for types and objects, PascalCase or UPPERCASE for constants.
- Avoid single-letter variable names, unless their lifespan is minimal. If your variable comes from a mathematical context or no confusion is possible with another variable, you may use single-letter variables. Generally, single-letter variables stop being OK if there's more than just a couple of them in a scope. Some examples:
  * Prefer `index` or `idx` to `i` for loops.
  * Prefer `src` and `dst` to `a` and `b`.
  * Prefer `remainder` to `r` and `prefix` to `p`.
- Expand acronyms. For instance, use `greatestCommonDivisor()` rather than `gcd()` for better clarity, especially for non-native English speakers.

#### Compilation

- The code should successfully compile using the stable version of the Nim compiler. It's a good idea to check compilation against the development version as well for future-proofing.

#### Types

- Use the strictest suitable types for input, output and object fields. Prefer `Natural`, `Positive` or custom [subrange types](https://nim-lang.org/docs/manual.html#types-subrange-types) over unconstrained `int` where applicable, use `Natural` for indexing.
- On the other hand, write generic code where appropriate. Do not impose arbitrary limitations if the code can work on a wider range of data types.
- Don't use unsigned numerical types (`uint` and its sized variants), unless wrapping behaviour or binary manipulation is required for the algorithm.
- Prefer the [`Option[T]`](https://nim-lang.org/docs/options.html) to encode an [optional value](https://en.wikipedia.org/wiki/Option_type) instead of using an invalid value (like the `-1` or an empty string `""`), unless it is critical for the algorithm. It may be also fitting if you are looking for the equivalent of "NULL" (default value for pointers)[^null].

#### Result return

- Prefer the expression-based return over using the implicitly declared `result` variable[^result].
- Use `return` keyword only for changing the control-flow of a function. Minimize such cases.

#### Exceptions and side-effects

- Raise Nim exceptions (`ValueError`, etc.) on erroneous input values.
- Use [exception tracking](https://nim-lang.org/docs/manual.html#effect-system-exception-tracking). Right after the module-level documentation, add a `{.push raises: [].}` module pragma. This enforces that all `func`s do not raise any exceptions. If they do raise at least one, list them all with the `raises` pragma after the return type and before the `=` sign like this: `func foo(bar: int) {.raises: [IOError].} =`.

#### Documentation, examples and tests

- Consider including a usage example after the module documentation and the `push raises` pragma in the top-level `runnableExamples` block.
- Use the [`std/unittest` module](https://nim-lang.org/docs/unittest.html) to test your code.
- We recommend using a `when isMainModule:` block to run tests. This block runs when the module is compiled as an executable. See the [minimal example](#minimal-example).

#### Other

- If you need a third-party module not listed in [third_party_modules.md](https://github.com/TheAlgorithms/Nim/blob/master/third_party_modules.md), please add it to that file as part of your submission.
- Use the export marker `*` to distinguish the functions of your user-facing [application programming interface (API)](https://en.wikipedia.org/wiki/API) from internal helper functions.

### Minimal example

```nim
## My Algorithm
##
## Description, explanation, recommendations, sources, links.
{.push raises: [].}

runnableExamples:
  echo myFunction("bla")

func myFunction*(s: string): string {.raises: [ValueError].} =
  ## Function documentation
  if s.len == 0:
    raise newException(ValueError, "Empty string")
  return s

when isMainModule:
  import std/unittest

  suite "A suite of tests":
    test "runs correctly":
      check myFunction("bla") == "bla"
    test "raises ValueError":
      expect(ValueError): discard myFunction("")

```

### Submissions Requirements

- Make sure the code [compiles](#compilation) before submitting.
- Look up the name of your algorithm in other active repositories of [TheAlgorithms](https://github.com/TheAlgorithms/), like [TheAlgorithms/Python](https://github.com/TheAlgorithms/Python). By reusing the same name, your implementation will be appropriately grouped alongside other implementations on the [project's website](https://the-algorithms.com/).
- Please help us keep our issue list small by adding fixes: Reference the number of the issue you solved — even if only partially — ino the commit message of your pull request.
- Use *snake_case* (words separated with an underscore `_`) for the filename.
- Try to fit your work into the existing directory structure as much as possible. If you want to create a new subdirectory, please open an issue first.
- Writing documentation, be concise and verify your spelling and grammar.
- Optionally but recommended, provide an explanation in [Algorithms-Explanation](https://github.com/TheAlgorithms/Algorithms-Explanation).
- Most importantly, **be consistent in adhering to these guidelines**.

**Happy coding!**

---

Authors: [@dlesnoff](https://github.com/dlesnoff), [@Zoom](https://github.com/ZoomRmc).

[^null]: If you are wondering why it's preferable to avoid Null references, you should check [Tony Hoare's report at the QCon 2009 conference](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/).
[^result]: Refer to comparison of different ways of returning results in [The Status Nim style guide](https://status-im.github.io/nim-style-guide/language.result.html).
