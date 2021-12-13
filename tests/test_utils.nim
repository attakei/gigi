import
  std/unittest,
  gigipkg/utils {.all.}


suite "getAppName":
  test "Get name":
    let appName = getAppName()
    check appName == "test_utils"
