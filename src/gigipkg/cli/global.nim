import confutils

type
  Command* = enum
    init = "Initialize workspace"

  GlobalOptions* = object
    logLevel* {.
      defaultValue: "INFO", desc: "Output logging's level", name: "log-level"
    .}: string
