import std/[dirs, options, paths, syncio, tempfiles, unittest]
import gigipkg/[bucket, consts, context, source]

let
  workDir = createTempDir("", "").Path
  workCtx = initContext(workDir, workDir)

test "Parse source name without bucket":
  let source = workCtx.parseSource("Nim")
  check source.isSome
  check source.get().bucket.name == DEFAULT_BUCKET
  check source.get().path == "Nim"

test "Parse source name with bucket":
  let source = workCtx.parseSource("github:Nim")
  check source.isSome
  check source.get().bucket.name == "github"
  check source.get().path == "Nim"
  check $source.get() == "github:Nim"

test "Parse invalid source name":
  check workCtx.parseSource("a:b:c").isNone

test "Resolve source from workspace":
  let
    dir = createTempDir("", "").Path
    ctx = initContext(dir, dir)
  createDir(ctx.bucketDir("github"))
  writeFile((ctx.bucketDir("github") / "Nim.gitignore").string, "nimcache/")
  check ctx.resolveSource("github:Nim").isSome
  check readContent(ctx.resolveSource("github:Nim").get()) == "nimcache/"
  check ctx.resolveSource("github:Python").isNone
  check ctx.resolveSource("a:b:c").isNone
