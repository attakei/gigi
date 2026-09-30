import std/[files, options, paths, sequtils, strutils, syncio]
import chronicles
import confutils/defs
import ../../[consts, context]

type
  CreateOptions* = object
    dest* {.defaultValue: ".gitignore", desc: "Output path".}: string
    force* {.defaultValue: false, desc: "Save file forcely".}: bool
    sources* {.argument, desc: "Target sources".}: seq[string]

  Source = object
    bucket: string
    path: string

proc `$`(source: Source): string =
  result = source.bucket & ":" & source.path

proc sourceExists(ctx: AppContext, source: Source): bool =
  let
    bucketPath = ctx.bucketDir(source.bucket)
    sourceFullpath = bucketPath / (source.path & ".gitignore")
  result = fileExists(sourceFullpath)

proc resolveSource(ctx: AppContext, target: string): Option[Source] =
  let parts = target.split(":")
  if len(parts) >= 3:
    return none(Source)
  let source =
    if len(parts) == 1:
      Source(bucket: DEFAULT_BUCKET, path: target)
    else:
      Source(bucket: parts[0], path: parts[1])
  if not sourceExists(ctx, source):
    return none(Source)
  return some(source)

proc getContent(ctx: AppContext, source: Source): string =
  let
    bucketPath = ctx.bucketDir(source.bucket)
    sourceFullpath = bucketPath / (source.path & ".gitignore")
  result = readFile(sourceFullpath.string)

proc execCreate*(ctx: AppContext, opts: CreateOptions) =
  let
    dest = Path(opts.dest)
    sources = opts.sources.mapIt(resolveSource(ctx, it))
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
      contentLines.add getContent(ctx, source)
      contentLines.add ""

    contentLines.add "#:gigi:user"

  writeFile(dest.string, contentLines.join("\n"))
