## Cache controller for API response
import std/[os, options, times], ./utils

const DEFAULT_EXPIRE_DAYS = 7
const DEFAULT_CACHE_FILE = "list.json"

proc getAppCacheDir*(): string =
  ## Get directory fullpath of application cache
  return getCacheDir() & DirSep & getAppName()

proc saveCache(path, content: string) =
  path.parentDir().createDir()
  path.writeFile(content)

proc saveCache*(content: string) =
  let cachePath = getAppCacheDir() & DirSep & DEFAULT_CACHE_FILE
  cachePath.saveCache(content)

proc loadCache*(
    src: string, ts: Time, expireDays: int = DEFAULT_EXPIRE_DAYS
): Option[string] =
  ## Read cache content if it is exists and is before expired.
  if not src.fileExists():
    return none(string)

  let
    stat = getFileInfo(src)
    delta = ts - stat.lastWriteTime
  if delta.inDays >= expireDays:
    return none(string)

  return some(src.readFile())

proc loadCache*(expireDays: int = DEFAULT_EXPIRE_DAYS): Option[string] =
  ## Simply using of ``loadCache``.
  ## - find default cache path
  ## - timesampe is current datetime
  let cachePath = getAppCacheDir() & DirSep & DEFAULT_CACHE_FILE
  return loadCache(cachePath, now().toTime(), expireDays)
