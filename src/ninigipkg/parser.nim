import std/[json, strutils, tables]
import ./core


proc parseTemplate(src: JsonNode): Template =
  let name = src["name"].getStr()
  let contents = src["contents"].getStr("").strip().splitLines()
  result = newTemplate(name, contents)


proc parseTemplates*(src: JsonNode): TemplatesTable =
  result = newTable[string, Template]()
  for key, tmpl in src.pairs:
    result[key] = parseTemplate(tmpl)
