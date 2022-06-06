import
  std/[json, options, os, parseopt, strutils, terminal],
  pkg/puppy,
  ./info, ./parser, ./utils, ./webapi,
  ./subcommands/[create, tui]


type
  Options = ref object of RootObj
    command: string
    targets: seq[string]
      ## Command targets
    dest: Option[string]
      ## If value is set, out into file fo dest instead of STDOUT


proc parseArgs(params: seq[string]): Options =
  result = Options(command: "create", targets: @[], dest: none(string))
  var p = initOptParser(params)
  while true:
    p.next()
    case p.kind:
      of cmdEnd: break
      of cmdLongOption, cmdShortOption:
        if p.key == "h" or p.key == "help":
          result.command = "help"
          break
        if p.key == "o" or p.key == "out":
          result.dest = some(p.val)
      of cmdArgument:
        result.targets.add(p.key)
  if result.targets.len == 0 and result.command == "create":
    result.command = "tui"


proc main*(): int =
  result = 1
  let
    options = parseArgs(commandLineParams())
  var
    targets = deepCopy(options.targets)

  if options.command == "help":
    result = 0
    stdout.writeLine(PKG_NAME & " version " & PKG_VERSION)
    stdout.writeLine("Usage: " & getAppName() & " [-h/--help] [-o/--out output] (TARGETS)")
    stdout.writeLine("")
    stdout.writeLine("  -h/--help  Display help text")
    stdout.writeLine("  -o/--out   Write output instead of STDOUT")
    stdout.writeLine("  TARGETS    Content targets (space separated)")
    return

  if not isatty(stdin):
    for line in readAll(stdin).strip().split("\n"):
      for token in line.split():
        if not token.startsWith("#"):
          targets.add(token)

  if targets.len == 0:
    stderr.writeLine("No targets is specified.")

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
    if options.command == "tui":
      tui.run(templates)
    else:
      result = strm.outputGitignore(templates, targets)
  except PuppyError:
    let ex = getCurrentException()
    stderr.writeLine("Failured to fetch ignore templates.")
    stderr.writeLine("Please see error messages and check your environment if you need.")
    stderr.writeLine("Message: " & ex.msg)
    return

  return
