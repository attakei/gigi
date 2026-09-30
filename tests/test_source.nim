import std/[dirs, options, paths, syncio, tempfiles, unittest]
import gigipkg/[consts, context, source]

test "Parse source name without bucket":
  let source = parseSource("Nim")
  check source.isSome
  check source.get().bucket == DEFAULT_BUCKET
  check source.get().path == "Nim"

test "Parse source name with bucket":
  let source = parseSource("github:Nim")
  check source.isSome
  check source.get().bucket == "github"
  check source.get().path == "Nim"
  check $source.get() == "github:Nim"

test "Parse invalid source name":
  check parseSource("a:b:c").isNone

test "Resolve source from workspace":
  let
    dir = createTempDir("", "").Path
    ctx = initContext(dir, dir)
  createDir(ctx.bucketDir("github"))
  writeFile((ctx.bucketDir("github") / "Nim.gitignore").string, "nimcache/")
  check ctx.resolveSource("github:Nim").isSome
  check ctx.readContent(ctx.resolveSource("github:Nim").get()) == "nimcache/"
  check ctx.resolveSource("github:Python").isNone
  check ctx.resolveSource("a:b:c").isNone
