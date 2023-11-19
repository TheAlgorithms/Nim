if defined(release) or defined(danger):
  --opt: speed
  --passC: "-flto"
  --passL: "-flto"
  --passL: "-s"
else:
  --checks: on
  --assertions: on
  --spellSuggest
  --styleCheck: error

--mm:arc

import std/[os, sequtils]
from std/strutils import startsWith, endsWith
from std/strformat import `&`

const IgnorePathPrefixes = ["."]

func isIgnored(path: string): bool =
  IgnorePathPrefixes.mapIt(path.startsWith(it)).anyIt(it)

iterator modules(dir: string = getCurrentDir()): string =
  ## Iterate over paths to all nim files in directory `dir`, skipping
  ## paths starting with substrings from the `IgnorePathPrefixes` const
  for path in walkDirRec(dir, relative = true):
    if not path.isIgnored() and path.endsWith(".nim"):
      yield path

############ Tasks
task test, "Test everything":
  --warning: "BareExcept:off"
  --hints: off
  var failedUnits: seq[string]

  for path in modules():
    echo &"Testing {path}:"
    try: selfExec(&"-f --warning[BareExcept]:off --hints:off r \"{path}\"")
    except OSError:
      failedUnits.add(path)
  if failedUnits.len > 0:
    echo "Failed tests:"
    for path in failedUnits:
      echo &"- {path}"
    quit(1)
  else:
    echo "All tests passed successfully"

task prettyfy, "Run nimpretty on everything":
  for path in modules():
    exec(&"nimpretty --indent:2 \"{path}\"")
