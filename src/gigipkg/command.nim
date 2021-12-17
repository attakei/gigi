import
  std/[json, options, os, parseopt, strutils, terminal],
  pkg/puppy,
  ./parser, ./webapi,
  ./subcommands/create


type
  Options = ref object of RootObj
    targets: seq[string]
      ## Command targets
    dest: Option[string]
      ## If value is set, out into file fo dest instead of STDOUT


proc parseArgs(params: seq[string]): Options =
  result = Options(targets: @[], dest: none(string))
  var p = initOptParser(params)
  while true:
    p.next()
    case p.kind:
      of cmdEnd: break
      of cmdLongOption, cmdShortOption:
        if p.key == "o" or p.key == "out":
          result.dest = some(p.val)
        discard
      of cmdArgument:
        result.targets.add(p.key)


proc main*(): int =
  result = 1
  let
    options = parseArgs(commandLineParams())
  var
    targets = deepCopy(options.targets)

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
    var
      strm =
        if isNone(options.dest):
          stdout
        else:
          open(options.dest.get(), fmWrite, -1)
    result = strm.outputGitignore(templates, targets)
  except PuppyError:
    let ex = getCurrentException()
    stderr.writeLine("Failured to fetch ignore templates.")
    stderr.writeLine("Please see error messages and check your environment if you need.")
    stderr.writeLine("Message: " & ex.msg)
    return

  return
