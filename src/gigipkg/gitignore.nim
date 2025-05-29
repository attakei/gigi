## Definition for gitignore template
import std/[strutils, tables]

type
  Gitignore* = ref object of RootObj ## Gigitnore entity of gigi
    name: string
    contents: seq[string]

  GitignoreTable* = TableRef[string, Gitignore] ## It is alias

proc name*(self: Gitignore): string =
  return self.name

proc newGitignore*(name: string, contents: seq[string]): Gitignore =
  result = Gitignore()
  result.name = name
  result.contents = contents

proc output*(self: Gitignore): string =
  ## Return gitignore body for output.
  ##
  ## It is used to write into ``.gitignore``.
  return self.contents.join("\n")

proc newGitignoreTable*(): GitignoreTable =
  ## Create empty table for Gitignore entities.
  result = newTable[string, Gitignore]()
