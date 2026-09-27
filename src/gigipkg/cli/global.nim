import confutils

type
  Command* = enum
    init = "Initialize workspace"

  GlobalOptions* = object
    logLevel* {.
      defaultValue: "WARN", desc: "Output logging's level", name: "log-level"
    .}: string
