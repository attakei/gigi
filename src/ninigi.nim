import std/[json, strutils, tables]


type
  Template = ref object of RootObj
    ## Template of language/environment of gitignore.io
    name: string
    contents: seq[string]
  TemplatesTable = TableRef[string, Template]


proc parseTemplate(src: JsonNode): Template =
  result = Template()
  result.name = src["name"].getStr()
  let contents = src["contents"].getStr("").strip().splitLines()
  result.contents = contents


proc parseTemplates(src: JsonNode): TemplatesTable =
  result = newTable[string, Template]()
  for key, tmpl in src.pairs:
    result[key] = parseTemplate(tmpl)


when isMainModule:
  echo("### NINIGI version 0.1.0")
