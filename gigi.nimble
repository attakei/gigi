# Package

version       = "0.1.0"
author        = "Kazuya Takei"
description   = "GitIgnore Generation Interface"
license       = "Apache-2.0"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gigi"]
binDir        = "bin"


# Dependencies

requires "nim >= 1.6.0"
requires "puppy >= 1.4.0"


task bundle, "Bundle resources for distribution":
  let binExt =
    when defined(windows):
      ".exe"
    else:
      ""
  mkDir("dist")
  for b in bin:
    let src = binDir & "/" & b & binExt
    let dst = "dist/" & b & binExt
    cpFile(src, dst)
  for f in @["LICENSE", "README.md"]:
    cpFile(f, "dist/" & f)
