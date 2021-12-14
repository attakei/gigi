## Management access to Web API
import
  std/[base64, options, os, uri],
  pkg/puppy,
  ./cache


const
  DEFAULT_WEBAPI_URL* = "https://www.toptal.com/developers/gitignore/api/list?format=json"
  DEFAULT_USER_AGENT  = "gigi web-client"


proc makeCacheKey(url: string): string =
  ## Generate cache key from parts of URL.
  let
    parsedUrl = parseUri(url)
    src = parsedUrl.hostname & "<>" & parsedUrl.query & "<>" & parsedUrl.path
  return encode(src, true)


proc fetchContent*(url: string = DEFAULT_WEBAPI_URL): string =
  ## Fetch raw content from Web API.
  let headers = @[
    Header(key: "User-Agent", value: DEFAULT_USER_AGENT),
  ]
  return fetch(url, headers = headers)


proc fetchContentOrCache*(url: string = DEFAULT_WEBAPI_URL): string =
  ## Fetch raw content from Web API. If cache is available, return it.
  let
    cachePath = getAppCacheDir() & DirSep & makeCacheKey(url) & ".json"
    cacheContent = loadCache(cachePath)
  if cacheContent.isSome():
    result = cacheContent.get()
  else:
    let content = fetchContent(url)
    saveCache(cachePath, content)
    result = content
