import
  os


# Package

version       = "0.3.0.alpha1"
author        = "Kazuya Takei"
description   = "GitIgnore Generate Interface"
license       = "Apache-2.0"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gigi"]
binDir        = "dist"


# Dependencies

requires "nim >= 2.2.12"
requires "chronicles >= 0.12.4"
requires "confutils >= 0.1.1"

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
