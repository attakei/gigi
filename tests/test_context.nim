import std/[dirs, files, paths, tempfiles, unittest]
import gigipkg/context

test "Create settings file":
  let
    dir = createTempDir("", "").Path
    ctx = initContext(dir, dir)
  ctx.initWorkspace()
  check fileExists(ctx.settingsPath)
  check dirExists(ctx.bucketDir("main"))
