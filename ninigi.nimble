# Package

version       = "0.1.0"
author        = "Kazuya Takei"
description   = "Ninigi Is Nim Implemented Gitignore.io Interface"
license       = "Apache-2.0"
srcDir        = "src"
installExt    = @["nim"]
binDir        = "bin"
namedBin["cli"] = "ninigi"


# Dependencies

requires "nim >= 1.6.0"
