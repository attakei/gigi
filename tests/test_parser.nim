import std/[json, unittest]

import gigipkg/gitignore
include gigipkg/parser


let data = parseJson("""{
  "nim": {
    "fileName": "Nim.gitignore",
    "key": "nim",
    "contents": "\n### Nim ###\nnimcache/\nnimblecache/\nhtmldocs/\n",
    "name": "Nim"
  }
}
""")


test "Parse content":
  let gi = parseGitignore(data["nim"])
  check gi.name == "Nim"
  check gi.output.splitLines.len == 4


test "Parse contents":
  let table = parseGitignoreTable(data)
  check table.len == 1
  check table["nim"].name == "Nim"
  check table["nim"].output.splitLines.len == 4
