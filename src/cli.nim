import std/[os, parseopt, tables]
import ninigi


when isMainModule:
  var p = initOptParser(commandLineParams())
  var targets: seq[string] = @[]
  while true:
    p.next()
    case p.kind:
      of cmdEnd: break
      of cmdLongOption, cmdShortOption:
        discard
      of cmdArgument:
        targets.add(p.key)

  if targets.len == 0:
    stderr.writeLine("No targets is specified.")
    quit(1)

  let templates = newTemplatesFromWeb()
  stdout.writeLine("### NINIGI version 0.1.0")
  for t in targets:
    if not templates.hasKey(t):
      stdout.writeLine("## '" & t & "' is not exists")
      continue
    stdout.writeLine("")
    stdout.writeLine(templates[t].output)
