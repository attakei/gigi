import std/[strutils, unittest]
import gigipkg/[gitignore, source]

test "Render document":
  let doc = GitignoreDoc(
    version: "0.3.0",
    arguments: @["Nim", "github:Python"],
    sections: @[
      SourceSection(source: Source(bucket: "github", path: "Nim"), content: "nimcache/"),
      SourceSection(source: Source(bucket: "github", path: "Python"), content: "*.pyc"),
    ],
  )
  let expected = [
    "#:gigi:version: 0.3.0", "#:gigi:arguments: Nim github:Python", "",
    "#:gigi:source: github:Nim", "nimcache/", "", "#:gigi:source: github:Python",
    "*.pyc", "", "#:gigi:user",
  ]
  check doc.render() == expected.join("\n")

test "Render document with user content":
  let doc = GitignoreDoc(version: "0.3.0", userContent: "local/")
  check doc.render().endsWith("#:gigi:user\nlocal/")
