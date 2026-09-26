import confutils

type AppConf = object
  logLevel {.defaultValue: "INFO".}: string

when isMainModule:
  let conf = AppConf.load()
  echo($conf)
