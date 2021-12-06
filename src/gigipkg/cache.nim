## Cache controller for API response
import
  std/[os, options, times],
  ./utils


const DEFAULT_EXPIRE_DAYS = 7
const DEFAULT_CACHE_FILE = "list.json"


proc getAppCacheDir*(): string =
  ## Get directory fullpath of application cache
  return getCacheDir() & DirSep & getAppName()


proc saveCache*(content: string) =
  let cachePath = getAppCacheDir() & DirSep & DEFAULT_CACHE_FILE
  cachePath.writeFile(content)


proc loadCache*(src: string, ts: Time, expireDays: int = DEFAULT_EXPIRE_DAYS): Option[string] =
  ## Read cache content if it is exists and is before expired.
  if not src.fileExists():
    return none(string)

  let
    stat = getFileInfo(src)
    delta = ts - stat.lastWriteTime
  if delta.inDays >= expireDays:
    return none(string)

  return some(src.readFile())

