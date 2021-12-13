import
  std/[os, strutils]


proc getAppName*(): string =
  ## Get application stem (filename without ext).
  return getAppFilename().lastPathPart.split(".")[0]
