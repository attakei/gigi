import std/[files, paths, tempfiles, unittest]
import gigipkg/context

test "Create settings file":
  let
    dir = createTempDir("", "").Path
    ctx = initContext(dir, dir)
  ctx.init()
  check fileExists(ctx.settingsPath)
