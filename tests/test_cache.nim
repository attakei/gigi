import
  std/[options, os, tempfiles, times, unittest],
  gigipkg/cache {.all.}


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


suite "saveCache":
  let
    tmpDir = createTempDir("test_utils--loadCache", "")
    tmpFilepath = tmpDir & DirSep & DEFAULT_CACHE_FILE
    content = "Caching content"

  test "Regular":
    saveCache(tmpFilepath, content)
    check tmpFilePath.fileExists()
    check tmpFilepath.getFileSize() == 15

  test "Create directory":
    let tmpFilepath = tmpDir & DirSep & "caches" & DirSep & DEFAULT_CACHE_FILE
    saveCache(tmpFilepath, content)
    check tmpFilePath.fileExists()

  test "Override":
    saveCache(tmpFilepath, content)
    check tmpFilepath.getFileSize() == 15
    saveCache(tmpFilepath, "Updated content caches")
    check tmpFilepath.getFileSize() == 22
