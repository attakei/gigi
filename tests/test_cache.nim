import
  std/[tempfiles, unittest]

include gigipkg/cache


suite "loadCache":
  let
    tmpDir = createTempDir("test_utils--loadCache", "")
    tmpFilepath = tmpDir & DirSep & DEFAULT_CACHE_FILE

  test "File not exists":
    check isNone(loadCache(tmpFilepath, now().toTime()))

  test "File is expired":
    tmpFilepath.writeFile("content")
    check isNone(loadCache(tmpFilepath, now().toTime(), 0))

  test "File can load":
    tmpFilepath.writeFile("content")
    let cached = loadCache(tmpFilepath, now().toTime(), 7)
    check isSome(cached)
    check cached.get() == "content"
