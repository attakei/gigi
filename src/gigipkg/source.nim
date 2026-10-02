## Source of Gitignore rules in buckets.
import std/[files, options, paths, strutils, syncio]
import ./[bucket, consts, context]

const SOURCE_EXT = ".gitignore"

type Source* = object
  bucket*: Bucket
  path*: string

proc `$`*(source: Source): string =
  result = source.bucket.name & ":" & source.path

proc parseSource*(ctx: AppContext, spec: string): Option[Source] =
  ## Parse source name ("BUCKET:PATH" or "PATH" for default bucket).
  let parts = spec.split(":")
  case len(parts)
  of 1:
    result = some(Source(bucket: ctx.initBucket(DEFAULT_BUCKET), path: spec))
  of 2:
    result = some(Source(bucket: ctx.initBucket(parts[0]), path: parts[1]))
  else:
    result = none(Source)

proc fullpath*(source: Source): Path =
  result = source.bucket.path / (source.path & SOURCE_EXT)

proc exists*(source: Source): bool =
  result = fileExists(source.fullpath)

proc readContent*(source: Source): string =
  result = readFile(source.fullpath.string)

proc resolveSource*(ctx: AppContext, spec: string): Option[Source] =
  ## Parse source name and return it only when it exists in workspace.
  let source = parseSource(ctx, spec)
  if source.isNone or not exists(source.get()):
    return none(Source)
  result = source
