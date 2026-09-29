import confutils/defs
import ../../context

type CreateOptions* = object
  dest* {.defaultValue: ".gitignore", desc: "Output path".}: string
  force* {.defaultValue: false, desc: "Save file forcely".}: bool
  sources* {.argument, desc: "Target sources".}: seq[string]

proc execCreate*(ctx: AppContext, opts: CreateOptions) =
  discard
