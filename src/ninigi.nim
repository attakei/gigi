import std/[httpclient, json, strutils, tables]


const DEFAULT_API_URL = "https://www.toptal.com/developers/gitignore/api/list?format=json"


type
  Template* = ref object of RootObj
    ## Template of language/environment of gitignore.io
    name: string
    contents: seq[string]
  TemplatesTable* = TableRef[string, Template]


proc output*(self: Template): string =
  result = self.contents.join("\n")


proc parseTemplate(src: JsonNode): Template =
  result = Template()
  result.name = src["name"].getStr()
  let contents = src["contents"].getStr("").strip().splitLines()
  result.contents = contents


proc parseTemplates(src: JsonNode): TemplatesTable =
  result = newTable[string, Template]()
  for key, tmpl in src.pairs:
    result[key] = parseTemplate(tmpl)


proc newTemplatesFromWeb*(url: string = DEFAULT_API_URL): TemplatesTable =
  let data = newHttpClient().get(url).body.parseJson()
  result = parseTemplates(data)
