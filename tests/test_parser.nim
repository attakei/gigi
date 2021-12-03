import std/[json, unittest]

import gigipkg/core
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
  let tmpl = parseTemplate(data["nim"])
  check tmpl.name == "Nim"
  check tmpl.output.splitLines.len == 4


test "Parse contents":
  let tmpls = parseTemplates(data)
  check tmpls.len == 1
  check tmpls["nim"].name == "Nim"
  check tmpls["nim"].output.splitLines.len == 4
