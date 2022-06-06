import
  os


# Package

version       = "0.2.1"
author        = "Kazuya Takei"
description   = "GitIgnore Generation Interface"
license       = "Apache-2.0"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gigi"]
binDir        = "bin"


# Dependencies

requires "nim >= 1.6.0"
requires "puppy == 1.4.0"


task bundle, "Bundle resources for distribution":
  let
    bundleDir = "gigi-v" & version
    binExt =
      when defined(windows):
        ".exe"
      else:
        ""
  mkDir(bundleDir)
  for b in bin:
    let src = binDir & "/" & b & binExt
    let dst = bundleDir & DirSep & b & binExt
    cpFile(src, dst)
  for f in @["LICENSE", "README.md"]:
    cpFile(f, bundleDir & DirSep & f)
