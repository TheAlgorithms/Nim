# Contributing guidelines

## Before contributing

Welcome to [TheAlgorithms/Nim](https://github.com/TheAlgorithms/Nim)! Before sending your pull requests, make sure that you __read the whole guidelines__. If you have any doubt on the contributing guide, please feel free to [state it clearly in an issue](https://github.com/TheAlgorithms/Nim/issues/new) or ask the community in [Discord](https://discord.gg/c7MnfGFGa6).

## Contributing

### Contributor

We are very happy that you are considering implementing algorithms and data structures for others! This repository is referenced and used by learners from all over the globe. Being one of our contributors, you agree and confirm that:

- You did your work - no plagiarism allowed
  - Any plagiarized work will not be merged.
- Your work will be distributed under [MIT License](LICENSE.md) once your pull request is merged
- Your submitted work fulfils or mostly fulfills our styles and standards

__New implementation__ is welcome! For example, new solutions for a problem, different representations for a graph data structure or algorithm designs with different complexity but __identical implementation__ of an existing implementation is not allowed. Please check whether the solution is already implemented or not before submitting your pull request.

__Improving comments__ and __writing proper tests__ are also highly welcome.

### Contribution

We appreciate any contribution, from fixing a grammar mistake in a comment to implementing complex algorithms. Please read this section if you are contributing your work.

Please help us keep our issue list small by adding fixes: Add the number of the issue you solved — even if only partially — to the commit message of your pull request. GitHub will use this tag to auto-close the issue when the PR is merged.

#### What is an Algorithm?

An Algorithm is one or more functions (or classes) that:
* take one or more inputs,
* perform some internal calculations or data manipulations,
* return one or more outputs,
* have minimal side effects (Examples of side effects: `echo()`, `plot()`, `read()`, `write()`).

Algorithms should be packaged in a way that would make it easy for readers to put them into larger programs.

Algorithms should:
* have intuitive object and function names that make their purpose clear to readers
* use Nim naming conventions and intuitive variable names with correct typing to ease comprehension
* Prefer `Natural`, `Positive` or custom [subrange types](https://nim-lang.org/docs/manual.html#types-subrange-types) to unconstrained `int` where applicable, use `Natural` for indexing.
* Don't use unsigned numerical types (`uint` and its sized variants), unless wrapping behaviour or binary manipulation is required for the algorithm.
* raise Nim exceptions (`ValueError`, etc.) on erroneous input values
* add the exceptions raised to the list of side effects
* have documentation comments with clear explanations and/or URLs to source materials
* contain doctests that test both valid and erroneous input values
* return all calculation results instead of printing or plotting them

Algorithms in this repo should not be how-to examples for existing Nim packages. Instead, they should perform internal calculations or manipulations to convert input values into different output values.  Those calculations or manipulations can use objects or functions of existing Nim modules but each algorithm in this repo should add unique value.

#### Coding Style

We want your work to be readable by others; therefore, we encourage you to note the following:

- Please write in Nim 2.0.
- Please focus hard on the naming of functions, objects, and variables.  Help your reader by using __descriptive names__ that can help you to remove redundant comments.
  - Single letter variable names must be avoided at all costs. You can use `index` instead of `i` when iterating in a `for` loop.
  - Expand acronyms. Prefer `greatestCommonDivisor()` to `gcd()`, as the former is easier to understand than the latter, especially for non-native English speakers.
  - Please follow the [Nim Naming Conventions](https://nim-lang.org/docs/nep1.html) so variable names and function names should be camelCase while object names should be PascalCase.

- Avoid importing external libraries for basic algorithms. Only use those libraries for complicated algorithms.
- If you need a third-party module that is not in the file [third_party_modules.md](https://github.com/TheAlgorithms/Nim/blob/master/third_party_modules.md), please add it to that file as part of your submission.

#### Other Requirements for Submissions
The file extension for code files should be `.nim`.
- Strictly use snake_case (underscore_separated) in your file_name, as it will be easy to parse in future using scripts.
- Please open an issue first if you want to create a new directory. Try to fit your work into the existing directory structure as much as possible.
- If possible, follow the standard *within* the folder you are submitting to.
- If you have modified/added code work, make sure the code compiles before submitting.
- If you have modified/added documentation work, ensure your language is concise and contains no grammar errors.
- Add a corresponding explanation to [Algorithms-Explanation](https://github.com/TheAlgorithms/Algorithms-Explanation) (Optional but recommended).

- Most importantly,
  - __Be consistent in the use of these guidelines when submitting.__
  - __Join__ us on [Discord](https://discord.gg/c7MnfGFGa6) __now!__
  - Happy coding!

Writer [@dlesnoff](https://github.com/dlesnoff), Mar 2023.
