import confutils
import ./cli/commands/[create, init]
import ./cli/global
import ./consts
import ./context
import ./vendor/chronicles/helpers

type AppConf* = object
  globalOpts {.flatten.}: GlobalOptions
  case command {.command.}: Command
  of Command.init:
    initOpts {.flatten.}: InitOptions
  of Command.create:
    createOpts {.flatten.}: CreateOptions

proc run*() =
  let conf = AppConf.load(version = APP_VERSION)
  setLogLevel(conf.globalOpts.logLevel)
  let ctx = initContext()
  case conf.command
  of Command.init:
    execInit(ctx, conf.initOpts)
  of Command.create:
    execCreate(ctx, conf.createOpts)
