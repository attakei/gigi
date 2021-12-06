import std/unittest

include gigipkg/utils


suite "getAppName":
  test "Get name":
    let appName = getAppName()
    check appName == "test_utils"
