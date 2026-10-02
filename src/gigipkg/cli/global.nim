import confutils

type
  Command* = enum
    init = "Initialize workspace"
    create = "Create Gitignore file"

  GlobalOptions* = object
    logLevel* {.
      defaultValue: "WARN", desc: "Output logging's level", name: "log-level"
    .}: string
