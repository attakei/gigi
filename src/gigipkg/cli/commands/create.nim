import std/[files, options, paths, sequtils, sets, syncio]
import chronicles
import confutils/defs
import ../../[bucket, consts, context, gitignore, source]

type CreateOptions* = object
  dest* {.defaultValue: ".gitignore", desc: "Output path".}: string
  force* {.abbr: "f", defaultValue: false, desc: "Save file forcely".}: bool
  update* {.
    abbr: "u",
    defaultValue: false,
    desc: "Update bucket of target sources before generate file"
  .}: bool
  sources* {.argument, desc: "Target sources".}: seq[string]

proc collectTargetBuckets(sources: seq[Source]): HashSet[Bucket] =
  result = toHashSet(sources.mapIt(it.bucket))

proc execCreate*(ctx: AppContext, opts: CreateOptions) =
  let dest = Path(opts.dest)
  if fileExists(dest) and not opts.force:
    warn "Destination file already exists", dest = dest
    echo "Command is canceled."
    return
  let sources = opts.sources.mapIt(resolveSource(ctx, it))
  if sources.anyIt(it.isNone):
    error "It requires that all arguments are valid source names"
    echo "Command is canceled."
    return
  let resolvedSources = sources.mapIt(it.get())
  if opts.update:
    trace "Updating buckets before generate destination files"
    for bucket in collectTargetBuckets(resolvedSources):
      trace "Updating bucket", bucket = bucket
      bucket.updateBucket
  let doc = GitignoreDoc(
    version: APP_VERSION,
    arguments: opts.sources,
    sections: resolvedSources.mapIt(SourceSection(source: it, content: readContent(it))),
  )
  writeFile(dest.string, doc.render())
