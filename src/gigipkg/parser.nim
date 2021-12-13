import
  std/[json, strutils, tables],
  ./gitignore


proc parseGitignore(src: JsonNode): Gitignore =
  let name = src["name"].getStr()
  let contents = src["contents"].getStr("").strip().splitLines()
  result = newGitignore(name, contents)


proc parseGitignoreTable*(src: JsonNode): GitignoreTable =
  result = newGitignoreTable()
  for key, tmpl in src.pairs:
    result[key] = parseGitignore(tmpl)
