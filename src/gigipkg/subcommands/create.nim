# CREATE command module
# =====================
#
# Output gitignore text.
import
  std/[strutils, tables],
  ../gitignore, ../info


proc createGitignore*(templates: GitignoreTable, targets: seq[string]): int =
  ## Create gitignore text into STDOUT.
  result = 1
  stdout.writeLine("### " & PKG_NAME & " version " & PKG_VERSION)
  stdout.writeLine("### command with: " & targets.join(" "))
  for t in targets:
    if not templates.hasKey(t):
      stdout.writeLine("## '" & t & "' is not exists")
      continue
    stdout.writeLine("")
    stdout.writeLine(templates[t].output)
  result = 0
