import std/[httpclient, json]
import ninigipkg/[core, parser]


const DEFAULT_API_URL = "https://www.toptal.com/developers/gitignore/api/list?format=json"


proc newTemplatesFromWeb*(url: string = DEFAULT_API_URL): TemplatesTable =
  let data = newHttpClient().get(url).body.parseJson()
  result = parseTemplates(data)


when isMainModule:
  import std/[os, parseopt, tables]
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
