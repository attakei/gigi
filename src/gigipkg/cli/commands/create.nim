import std/[files, options, paths, sequtils, strutils, syncio]
import chronicles
import confutils/defs
import ../../[consts, context, source]

type CreateOptions* = object
  dest* {.defaultValue: ".gitignore", desc: "Output path".}: string
  force* {.abbr: "f", defaultValue: false, desc: "Save file forcely".}: bool
  sources* {.argument, desc: "Target sources".}: seq[string]

proc execCreate*(ctx: AppContext, opts: CreateOptions) =
  let
    dest = Path(opts.dest)
    sources = opts.sources.mapIt(resolveSource(ctx, it))
  if fileExists(dest) and not opts.force:
    warn "Destination file already exists", dest = dest
    echo "Command is canceled."
    return
  if sources.anyIt(it.isNone):
    error "It requires that all arguments are valid source names"
    return
  var contentLines: seq[string] = @[]

  block:
    contentLines.add "#:gigi:version: " & APP_VERSION
    contentLines.add "#:gigi:arguments: " & opts.sources.join(" ")
    contentLines.add ""
    for source in sources.mapIt(it.get()):
      contentLines.add "#:gigi:source: " & $source
      contentLines.add ctx.readContent(source)
      contentLines.add ""

    contentLines.add "#:gigi:user"

  writeFile(dest.string, contentLines.join("\n"))
