import confutils/defs

type InitOptions* = object
  clean* {.abbr: "c", defaultValue: false, desc: "Clean initialize (remove old files)".}:
    bool
