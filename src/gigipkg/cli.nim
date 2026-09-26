import confutils
import ./cli/commands/[init]
import ./cli/global

type AppConf* = object
  globalOpts {.flatten.}: GlobalOptions
  case command {.command.}: Command
  of Command.init:
    initOpts {.flatten.}: InitOptions

proc run*() =
  let conf = AppConf.load()
  echo($conf)
