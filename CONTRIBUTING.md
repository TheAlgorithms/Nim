# Contributing guidelines

Welcome to [TheAlgorithms/Nim](https://github.com/TheAlgorithms/Nim)! Before you send your pull requests, please make sure that you **read the whole guidelines**. If you have any doubt about the contributing guide, please feel free to [state it clearly in an issue](https://github.com/TheAlgorithms/Nim/issues/new) or ask the community in [Discord](https://the-algorithms.com/discord).

## Contributing

We are very happy that you are considering implementing algorithms and data structures for others!\
This repository is referenced and used by learners from all over the globe. Being one of our contributors, you agree and confirm that:

- You did your work - no plagiarism allowed
  - Any plagiarized work will not be merged.
- Your work will be distributed under [MIT License](LICENSE.md) once your pull request is merged
- Your submitted work fulfills our styles and standards

__New implementation__ is welcome! For example, new solutions for a problem, different representations for a graph data structure or algorithm designs with different complexity but __identical implementation__ of an existing implementation is not allowed. Please check whether the solution is already implemented or not before submitting your pull request.

**Improving comments__ and **writing proper tests** are also highly welcome.

### Contribution

We appreciate any contribution, from fixing a grammar mistake in a comment to implementing complex algorithms. Please read this section if you are contributing your work.

Please help us keep our issue list small by adding fixes: Add the number of the issue you solved — even if only partially — to the commit message of your pull request. GitHub will use this tag to auto-close the issue when the PR is merged.

#### What is an Algorithm?

An Algorithm is one or more functions (or classes) that:
* take one or more inputs,
* perform some internal calculations or data manipulations,
* return one or more outputs,
* have minimal side effects (Examples of side effects: `echo()`, `rand()`, `read()`, `write()`).

Algorithms should be packaged in a way that would make it easy for readers to put them into larger programs.

Algorithms should:
* have intuitive object and function names that make their purpose clear to readers
* use Nim naming conventions and intuitive variable names with correct typing to ease comprehension
* Don't use unsigned numerical types (`uint` and its sized variants), unless wrapping behaviour or binary manipulation is required for the algorithm.
* raise Nim exceptions (`ValueError`, etc.) on erroneous input values
* The side effects must be annotated
* have documentation comments with clear explanations and/or URLs to source materials
* contain tests (runnableExamples, std/unittest) that test both valid and erroneous input values
* return all calculation results instead of printing or plotting them

Please focus hard on the naming of functions, objects, and variables.  Help your reader by using __descriptive names__ that can help you to remove redundant comments.
  - Single letter variable names must be avoided unless your variable has a short lifespan. If your variable come from a mathematical context, no confusion is possible with another variable, you may use single-letter variables. When there are multiple indices (matrix, sums integrals) you may use single-letter variables. For string algorithms, `c` for character is a common use. Pay attention though not creating any confusion when dealing with multiple characters.
  You can use `index` instead of `i` when iterating in a `for` loop.
  - For some parameters, using short variable names enable to distinguish the inputs easily from the parameters.
  - Expand acronyms. Prefer `greatestCommonDivisor()` to `gcd()`, as the former is easier to understand than the latter, especially for non-native English speakers.
  - The variable and function names should be camelCase while object names should be PascalCase.
- Pay attention to spacing around operators.
- Avoid importing external libraries for basic algorithms. Only use those libraries for complicated algorithms.

Algorithms in this repo should not be how-to examples for existing Nim packages. Instead, they should perform internal calculations or manipulations to convert input values into different output values.  Those calculations or manipulations can use objects or functions of existing Nim modules but each algorithm in this repo should add unique value.

#### Nim Coding Style

We want your work to be readable by others; therefore, we encourage you to follow the [Nim Coding Style](https://nim-lang.org/docs/nep1.html) that is enforced in the Nim compiler and Standard Library.

We also enforce some additional rules:

- Please compile using the stable version of the Nim compiler. The 2.0 version is not out as we wrote these lines but you can compile against the pre-release version of the compiler: [https://nim-lang.org/blog/2022/12/21/version-20-rc.html].
- Prefer `Natural`, `Positive` or custom [subrange types](https://nim-lang.org/docs/manual.html#types-subrange-types) to unconstrained `int` where applicable, use `Natural` for indexing.
- Add the title of your algorithm (in Camel Case) with a comment on the top of your file
- Right under the title, add a `{.push raises: [].}`. This enforces that by default all `func`s have an empty list of exceptions. If they do raise at least an exception, then write after the return type and before the `=` sign, the list of exceptions raised in a similar pragma: `{.raises: [IOError].}`.
- If you need a third-party module that is not in the file [third_party_modules.md](https://github.com/TheAlgorithms/Nim/blob/master/third_party_modules.md), please add it to that file as part of your submission.
- If you are searching for the equivalent of `NULL` (default value for pointers), you might look for [`std/options`](https://nim-lang.org/docs/options.html) instead. 
Using the specific `Option[T]` generic type adds compile-time checks.
If you are wondering why we prefer to avoid Null references, you should check [Tony Hoare's conference at QCon 2009](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/).
- For your code to be integrated in larger modules, we recommend using a `when isMainModule` clause to run tests and examples.
- It is incited to give a usage example under a top-level `runnableExamples` on top of the file (under the title and the `push raises` pragma).
- You are not enforced to use the export marker `*`. It is preferable to use it in order to distinguish helper functions with internal details and the functions of your [application programming interface (API)](https://en.wikipedia.org/wiki/API) for the end user.
- You can use the `std/unittest` module from the standard library to test your program. Below is a sample of code.
  
```nim
#My Algorithm
{.push raises: [].}

runnableExamples:
  echo myFunction("bla")

func myFunction(s: string): string {.raises: [ValueError].} =
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

#### Submissions Requirements

- The file extension for algorithm files should be `.nim`.
- Look up if the name of your algorithm already exists in another repository of [TheAlgorithms](https://github.com/TheAlgorithms/) like [TheAlgorithms/Python](https://github.com/TheAlgorithms/Python). By reusing the same name, your implementation will be regrouped with implementations of other languages.
- Strictly use snake_case (underscore_separated) in your file_name, as it will be easy to parse in future using scripts.
- Please open an issue first if you want to create a new directory. Try to fit your work into the existing directory structure as much as possible.
- If possible, follow the standard *within* the folder you are submitting to.
- If you have modified/added code work, make sure the code compiles before submitting. Please precise the version of the compiler you used in your Pull Request.
- If you have modified/added documentation work, ensure your language is concise and contains no grammar errors.
- Add a corresponding explanation to [Algorithms-Explanation](https://github.com/TheAlgorithms/Algorithms-Explanation) (Optional but recommended).

- Most importantly,
  - __Be consistent in the use of these guidelines when submitting.__
  - __Join__ us on [Discord](https://discord.gg/c7MnfGFGa6) __now!__
  - Happy coding!

Writer [@dlesnoff](https://github.com/dlesnoff), Mar 2023.
