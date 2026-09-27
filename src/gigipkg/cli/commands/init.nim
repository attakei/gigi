import std/[dirs, paths]
import chronicles
import confutils/defs
import ../../context

type InitOptions* = object
  clean* {.abbr: "c", defaultValue: false, desc: "Clean initialize (remove old files)".}:
    bool

proc execInit*(ctx: AppContext, opts: InitOptions) =
  if opts.clean:
    removeDir(ctx.settingsDir)
    removeDir(ctx.dataDir)
  elif not ctx.canCreate:
    warn "Workspace files already exists",
      settingsDir = ctx.settingsDir, dataDir = ctx.dataDir
    return
  ctx.init()
