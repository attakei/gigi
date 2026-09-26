import confutils
import ./cli/commands/[init]
import ./cli/global
import ./vendor/chronicles/helpers

type AppConf* = object
  globalOpts {.flatten.}: GlobalOptions
  case command {.command.}: Command
  of Command.init:
    initOpts {.flatten.}: InitOptions

proc run*() =
  let conf = AppConf.load()
  setLogLevel(conf.globalOpts.logLevel)
  case conf.command
  of Command.init:
    execInit(conf.initOpts)
