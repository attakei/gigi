import std/[files, options, paths, sequtils, syncio]
import chronicles
import confutils/defs
import ../../[consts, context, gitignore, source]

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
    echo "Command is canceled."
    return
  let doc = GitignoreDoc(
    version: APP_VERSION,
    arguments: opts.sources,
    sections:
      sources.mapIt(SourceSection(source: it.get(), content: ctx.readContent(it.get()))),
  )
  writeFile(dest.string, doc.render())
