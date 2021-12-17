# GIGI

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/attakei/gigi)](https://nimble.directory/pkg/gigi)
[![Test](https://github.com/attakei/gigi/actions/workflows/test.yml/badge.svg)](https://github.com/attakei/gigi/actions/workflows/test.yml)

GIGI: GitIgnore Generation Interface

## Overview

GIGI is gitignore.io client library for Nim, included small cli application.

## Installation

### CLI binary

You can get standalone binary from [GitHub Release page](https://github.com/attakei/gigi/releases).

Windows users can use binary without Nim development environment and MinGW DLLs.

### Build from source

You can build binary from sources by `nimble`.

```sh
$ nimble install gigi
```

If you want to use cli, set your nimble bin directory to `$PATH`.

## Usage

Currently, it have only to output .gitignore contents from templates by arguments.

```sh
$ gigi nim
### GIGI version 0.2.1
### command with: nim

### Nim ###
nimcache/
nimblecache/
htmldocs/
```

Support `STDIN` .

```sh
$ echo nim | gigi
### GIGI version 0.2.1
### command with: nim

### Nim ###
nimcache/
nimblecache/
htmldocs/
```

## Changelogs

See [CHANGES](./CHANGES.md).

## License

See [LICENSE](./LICENSE).
