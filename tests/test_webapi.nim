import
  std/[unittest],
  gigipkg/webapi {.all.}


test "makeCacheKey":
  let srcUrl = "https://example.com"
  let cacheKey = makeCacheKey(srcUrl)
  check cacheKey == "ZXhhbXBsZS5jb208Pjw-"
