## Source of Gitignore rules in buckets.
import std/[files, options, paths, strutils, syncio]
import ./[consts, context]

const SOURCE_EXT = ".gitignore"

type Source* = object
  bucket*: string
  path*: string

proc `$`*(source: Source): string =
  result = source.bucket & ":" & source.path

proc parseSource*(spec: string): Option[Source] =
  ## Parse source name ("BUCKET:PATH" or "PATH" for default bucket).
  let parts = spec.split(":")
  case len(parts)
  of 1:
    result = some(Source(bucket: DEFAULT_BUCKET, path: spec))
  of 2:
    result = some(Source(bucket: parts[0], path: parts[1]))
  else:
    result = none(Source)

proc sourcePath*(ctx: AppContext, source: Source): Path =
  result = ctx.bucketDir(source.bucket) / (source.path & SOURCE_EXT)

proc sourceExists*(ctx: AppContext, source: Source): bool =
  result = fileExists(ctx.sourcePath(source))

proc readContent*(ctx: AppContext, source: Source): string =
  result = readFile(ctx.sourcePath(source).string)

proc resolveSource*(ctx: AppContext, spec: string): Option[Source] =
  ## Parse source name and return it only when it exists in workspace.
  let source = parseSource(spec)
  if source.isNone or not ctx.sourceExists(source.get()):
    return none(Source)
  result = source
