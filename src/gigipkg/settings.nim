## Settings schema for v0.3
import std/[json, jsonutils, tables]

const DEFAULT_SETTINGS = """
{
  "version": 1,
  "buckets": {
    "main": {
      "source": "https://github.com/github/gitignore",
      "branch": "main"
    }
  }
}
"""

type
  BucketSettings* = object
    source*: string
    branch*: string

  Settings* = object
    version: int
    buckets*: Table[string, BucketSettings]

proc createSettings*(): Settings =
  result = DEFAULT_SETTINGS.parseJson().jsonTo(Settings)
