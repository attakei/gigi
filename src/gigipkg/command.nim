import
  std/[json, os, parseopt, strutils, terminal],
  pkg/puppy,
  ./parser, ./webapi,
  ./subcommands/create


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
  result = 1
  var targets = parseArgs(commandLineParams())

  if not isatty(stdin):
    for line in readAll(stdin).strip().split("\n"):
      for token in line.split():
        if not token.startsWith("#"):
          targets.add(token)

  if targets.len == 0:
    stderr.writeLine("No targets is specified.")
    return

  try:
    let
      content = fetchContentOrCache()
      templates = parseGitignoreTable(content.parseJson())
    result = createGitignore(templates, targets)
  except PuppyError:
    let ex = getCurrentException()
    stderr.writeLine("Failured to fetch ignore templates.")
    stderr.writeLine("Please see error messages and check your environment if you need.")
    stderr.writeLine("Message: " & ex.msg)
    return

  return
