import
  std/[json, options, os, parseopt, strutils, tables],
  pkg/puppy,
  ./cache, ./gitignore, ./info, ./parser


const DEFAULT_API_URL = "https://www.toptal.com/developers/gitignore/api/list?format=json"
const DEFAULT_USER_AGENT = "gigi web-client"


proc fetchContent(url: string): string =
  let headers = @[
    Header(key: "User-Agent", value: DEFAULT_USER_AGENT),
  ]
  return fetch(url, headers = headers)


proc newTemplatesFromWeb*(url: string = DEFAULT_API_URL): GitignoreTable =
  return parseGitignoreTable(fetchContent(url).parseJson())


proc newTemplatesFromCache*(url: string = DEFAULT_API_URL): GitignoreTable =
  let cacheContent = loadCache()
  if cacheContent.isSome():
      return parseGitignoreTable(cacheContent.get().parseJson())
  else:
    let content = fetchContent(url)
    saveCache(content)
    return parseGitignoreTable(content.parseJson())


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

  try:
    let templates = newTemplatesFromCache()
    stdout.writeLine("### " & PKG_NAME & " version " & PKG_VERSION)
    stdout.writeLine("### command with: " & targets.join(" "))
    for t in targets:
      if not templates.hasKey(t):
        stdout.writeLine("## '" & t & "' is not exists")
        continue
      stdout.writeLine("")
      stdout.writeLine(templates[t].output)
  except PuppyError:
    let ex = getCurrentException()
    stderr.writeLine("Failured to fetch ignore templates.")
    stderr.writeLine("Please see error messages and check your environment if you need.")
    stderr.writeLine("Message: " & ex.msg)
    return 1

  return 0
