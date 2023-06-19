## Build the contents of `directory.md` for The Algorithms/Nim repository
##
## # Usage:
## * Navigate to repo's root directory
## * Execute and save the output: `nim r .scripts/directory.nim > DIRECTORY.md`
## * Check the changes: `git diff directory.md`
##
## # Overview:
## - Walks the current directory for subdirectories.
## - Each subdirectory (but not the root) is treated as a category.
## - The title of the category is inferred from the subdir's name.
## - Walks .nim source files in each subdirectory, non-recursively.
## - Looks for algorithms's title on the first line of the file when it's a
##   doc comment, otherwise canonicalizes the file basename.
## - Prints the markdown header.
## - Prints the collected directory structure sorted alphabetically in markdown.

import std/[os, unicode, critbits, options, strformat]
from std/strutils import startsWith, Whitespace, splitLines
from std/strbasics import strip

const
  # unicodeSpaces from unicode_ranges in stdlib are not public
  WhitespaceUC = toRunes("_\t\n\x0b\x0c\r\x1c\x1d\x1e\x1f \x85\xa0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u2028\u2029\u202f\u205f\u3000")
  Warning = "<!--- DO NOT EDIT: This file is automatically generated by `directory.nim` -->\n"
  Header = "# The Algorithms — Nim: Directory Hierarchy\n"

type
  ## TODO: Allow nested structure with variant type [Directory | CritBitTree[string]]
  Directory = CritBitTree[CritBitTree[string]]

func canonicalize(s: string): string =
  ## Splits input by whitespace and underscore, titlecases each word and
  ## joins them in the result with spaces. Consecutive whitespace is merged.
  ## Slightly Unicode-aware.
  var isFirst = true
  for word in unicode.split(s, WhitespaceUC):
    if word.len > 0:
      if isFirst: isFirst = false
      else: result.add(' ')
      result.add(word.title())

proc extractTitle(s, fpath: string): Option[string] =
  ## Reads the title of the file from its first line if it's a doc comment.
  var s = s.strip()
  if s.startsWith("##"):
    s.strip(trailing = false, chars = Whitespace + {'#'})
    if s.len > 0: some(s)
    else: none(string)
  else:
    stderr.writeLine(&"\u26A0: \"{fpath}\". First line is not a doc comment! Deriving title from the file name.")
    none(string)

proc readLn(fpath: string): Option[string] =
  ## Tries its best to read the first line of the file
  var f: File = nil
  var s: string
  if open(f, fpath):
    try:
      if not readLine(f, s): none(string)
      else: s.extractTitle(fpath)
    except CatchableError: none(string)
    finally: close(f)
  else: none(string)

proc collectDirectory(dir = ""): Directory =
  ## Walks the subdirectories of `dir` non-recursively, collects `.nim` files
  ## and their titles into a sorted structure. Dotfiles are skipped.
  for (pc, path) in walkDir(dir, relative = true):
    if pc == pcDir and path[0] != '.':
      var categoryDir: CritBitTree[string]
      for (pc, fname) in walkDir(path, relative = true):
        if pc == pcFile and fname[0] != '.':
          let (_, name, ext) = splitFile(fname)
          let fpath = path / fname
          if ext == ".nim":
            # if can't read the title from the source, derive from the file name
            let title = readLn(fpath).get(name.canonicalize())
            categoryDir[title] = fname
      if categoryDir.len > 0:
        result[path] = categoryDir

when isMainModule:
  let directory = collectDirectory(getCurrentDir())
  if directory.len > 0:
    echo Warning, "\n", Header
    for (categoryDir, contents) in directory.pairs():
      if contents.len > 0:
        echo "## ", categoryDir.canonicalize()
        for (title, fname) in contents.pairs():
          echo &"  * [{title}]({categoryDir}/{fname})" # note the hardcoded separator
        echo ""
