# CREATE command module
# =====================
#
# Output gitignore text.
import std/[strutils, tables], ../gitignore, ../info

proc outputGitignore*(
    strm: var File, templates: GitignoreTable, targets: seq[string]
): int =
  ## Create gitignore text into STDOUT.
  result = 1
  strm.writeLine("### " & PKG_NAME & " version " & PKG_VERSION)
  strm.writeLine("### command with: " & targets.join(" "))
  for t in targets:
    if not templates.hasKey(t):
      strm.writeLine("## '" & t & "' is not exists")
      continue
    strm.writeLine("")
    strm.writeLine(templates[t].output)
  result = 0
