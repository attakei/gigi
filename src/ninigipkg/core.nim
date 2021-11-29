import std/[strutils, tables]


type
  Template* = ref object of RootObj
    ## Template of language/environment of gitignore.io
    name: string
    contents: seq[string]
  TemplatesTable* = TableRef[string, Template]


proc name*(self: Template): string =
  return self.name


proc output*(self: Template): string =
  return self.contents.join("\n")


proc newTemplate*(name: string, contents: seq[string]): Template =
  result = Template()
  result.name = name
  result.contents = contents
