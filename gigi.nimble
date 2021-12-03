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
