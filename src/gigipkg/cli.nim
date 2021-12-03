import std/[json, os, parseopt, strutils, tables]
import pkg/puppy
import core
import parser


const DEFAULT_API_URL = "https://www.toptal.com/developers/gitignore/api/list?format=json"


proc newTemplatesFromWeb*(url: string = DEFAULT_API_URL): TemplatesTable =
  let data = fetch(url).parseJson()
  result = parseTemplates(data)


proc parseArgs(params: seq[string]): seq[string] =
  result = @[]
  var p = initOptParser(params)
  while true:
    p.next()
    case p.kind:
      of cmdEnd: break
      of cmdLongOption, cmdShortOption:
        discard
      of cmdArgument:
        result.add(p.key)


proc main*(): int =
  let targets = parseArgs(commandLineParams())

  if targets.len == 0:
    stderr.writeLine("No targets is specified.")
    return 1

  let templates = newTemplatesFromWeb()
  stdout.writeLine("### NINIGI version 0.1.0")
  stdout.writeLine("### command with: " & targets.join(" "))
  for t in targets:
    if not templates.hasKey(t):
      stdout.writeLine("## '" & t & "' is not exists")
      continue
    stdout.writeLine("")
    stdout.writeLine(templates[t].output)

  return 0
