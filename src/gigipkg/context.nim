## Context manager
import std/[appdirs, dirs, files, json, jsonutils, logging, paths, syncio]
import ./settings

const
  APP_NAME = "gigi"
  SETTINGS_FILENAME = "settings.json"

type AppContext* = object
  settingsDir: Path
  dataDir: Path

proc `/`(head: Path, tail: string): Path =
  result = head / Path(tail)

proc getAppSettingsDir*(): Path =
  result = getConfigDir() / APP_NAME

proc getAppDataDir*(): Path =
  result = getDataDir() / APP_NAME

proc initContext*(
    settingsDir: Path = getAppSettingsDir(), dataDir: Path = getAppDataDir()
): AppContext =
  result.settingsDir = settingsDir
  result.dataDir = dataDir

proc settingsPath*(ctx: AppContext): Path =
  result = ctx.settingsDir / SETTINGS_FILENAME

proc init*(ctx: AppContext) =
  debug "Create context folders"
  if not fileExists(ctx.settingsDir):
    createDir(ctx.settingsDir)
  if not fileExists(ctx.dataDir):
    createDir(ctx.dataDir)
  debug "Initialize settings"
  let settings = createSettings()
  writeFile(ctx.settingsPath().string, $settings.toJson())
