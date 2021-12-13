## Management access to Web API
import
  std/options,
  pkg/puppy,
  ./cache


const
  DEFAULT_WEBAPI_URL* = "https://www.toptal.com/developers/gitignore/api/list?format=json"
  DEFAULT_USER_AGENT  = "gigi web-client"


proc fetchContent*(url: string = DEFAULT_WEBAPI_URL): string =
  ## Fetch raw content from Web API.
  let headers = @[
    Header(key: "User-Agent", value: DEFAULT_USER_AGENT),
  ]
  return fetch(url, headers = headers)


proc fetchContentOrCache*(url: string = DEFAULT_WEBAPI_URL): string =
  ## Fetch raw content from Web API. If cache is available, return it.
  let cacheContent = loadCache()
  if cacheContent.isSome():
    result = cacheContent.get()
  else:
    let content = fetchContent(url)
    saveCache(content)
    result = content
