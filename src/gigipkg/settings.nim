## Settings schema for v0.3
import std/[json, jsonutils, tables]

const DEFAULT_SETTINGS = """
{
  "version": 1
}
"""

type Settings* = object
  version: int

proc createSettings*(): Settings =
  result = DEFAULT_SETTINGS.parseJson().jsonTo(Settings)
